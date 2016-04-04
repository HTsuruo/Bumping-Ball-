//
//  GameScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright (c) 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = Ball()
    var targetBall = TargetBall()
    let ballUtil = BallUtils()
    var last: CFTimeInterval!
    var screenWidth: Int!
    var removeHeight: CGFloat = 0.0
    
    // 当たり判定のカテゴリを準備する.
    let ballCategory: UInt32 = 0x1 << 0
    let targetBallCategory: UInt32 = 0x1 << 1
    
    override func didMoveToView(view: SKView) {
        //ここは物理世界.
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = CGFloat(0.8)
        
        self.backgroundColor = UIColor.blackColor()
        self.screenWidth = Int(define.WIDTH)
    
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "score"
        myLabel.fontSize = 30
        myLabel.fontColor = UIColor.whiteColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-30)
        self.addChild(myLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if self.paused {//ポーズ中は入力出来ないように.
            return
        }
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            ball = Ball()
            ball.setLocation(location.x, posY: location.y + define.TOUCH_MARGIN)
            ball.setCategory(ballCategory, targetCat: targetBallCategory)
    
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            ball.ball.runAction(SKAction.repeatActionForever(action))
            self.addChild(ball.ball)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touche in touches {
            let location = touche.locationInNode(self)
            ball.ball.position.x = location.x
            ball.ball.position.y = location.y + define.TOUCH_MARGIN
         }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        ball.ball.runAction(Sound.launch)
        ball.isFire = true
        ball.setIsFire()
        let actionMove = SKAction.moveToY(define.REMOVE_HEIGHT, duration: Double(ball.ballSpeed))
        ball.ball.runAction(actionMove)
    }
   
    override func update(currentTime: CFTimeInterval) {
        removeBall()
        if  !ball.isFire {
            sizeChange()
        }
        
        // lastが未定義ならば、今の時間を入れる。
        if last == nil {
            last = currentTime
        }
        // 1秒おきにtargetBallを作成する.
        if last + 1 <= currentTime {
            //targetBallが生成される場所を決める.
            let targetXPos: UInt! = UInt(CGRectGetMidX(self.frame))
                + UInt(arc4random_uniform(UInt32(self.screenWidth)))
                - UInt(self.screenWidth / 2)
            createTargetBall(targetXPos)
            last = currentTime
        }
    }
    
    private func removeBall() {
        self.enumerateChildNodesWithName("ball", usingBlock: {
            node, step in
            if node is SKSpriteNode {
                let ball = node as! SKSpriteNode
                //物理演算を取り入れると0.1足りなくなるので
                if ball.position.y >= define.REMOVE_HEIGHT-1 {
                    ball.runAction(SKAction.fadeOutWithDuration(0.3), completion: {
                        ball.removeFromParent()
                    })
                }
            }
        })
    }
    
    private func sizeChange() {
        ball.ballScale += 0.025
        if ball.ballScale < 0.8 {
            ball.ballSpeed = define.BALL_INIT_SPEED
            ball.ball.runAction(ballUtil.setBlue())
            ball.setId(BallType.BLUE.rawValue)
        } else if ball.ballScale < 1.1 {
            ball.ballSpeed = 0.75
            ball.ball.runAction(ballUtil.setGreen())
            ball.setId(BallType.GREEN.rawValue)
        } else if ball.ballScale < 1.4 {
            ball.ballSpeed = 1.0
            ball.ball.runAction(ballUtil.setOrange())
            ball.setId(BallType.ORANGE.rawValue)
        } else if ball.ballScale < 1.7 {
            ball.ballSpeed = 1.25
            ball.ball.runAction(ballUtil.setRed())
            ball.setId(BallType.RED.rawValue)
        } else {
            ball.ballScale = define.BALL_INIT_SCALE
            ball.ballSpeed = define.BALL_INIT_SPEED
            ball.ball.runAction(ballUtil.setBlue())
            ball.setId(BallType.BLUE.rawValue)
        }
        ball.ball.setScale(ball.ballScale)
    }
    
    private func createTargetBall(posX: UInt) {
        targetBall = TargetBall()
        targetBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        targetBall.ball.physicsBody?.affectedByGravity = true
        targetBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(self.targetBall.ball)
        targetBall.ball.runAction(SKAction.fadeInWithDuration(0.5))
    }
    
    //衝突したときの処理.
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        // first: ball, second: targetBallとした.
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //消滅させることができるのは発射したボールのみ.
        let isFire = firstBody.node?.userData?.valueForKey("isFire")
        if isFire == nil {
            return
        }
        if !(isFire as! Bool) {
            return
        }
        
        let myId = firstBody.node?.userData?.valueForKey("id")
        let targetId = secondBody.node?.userData?.valueForKey("id")
        
        if myId == nil || targetId == nil {
            return
        }
        if myId as! Int != targetId as! Int {
            return
        }
        
        // ballとtargetballが接触した時の処理
        if targetId != nil {
            if firstBody.categoryBitMask & ballCategory != 0 &&
                secondBody.categoryBitMask & targetBallCategory != 0 {
                    removeBothBalls(secondBody.node!, id: targetId as! Int)
                    firstBody.node?.removeFromParent()
            }
        }
    }
    
    func removeBothBalls(node: SKNode, id: Int) {
        let sparkPath = NSBundle.mainBundle().pathForResource("spark", ofType: "sks")
        let spark = NSKeyedUnarchiver.unarchiveObjectWithFile(sparkPath!) as! SKEmitterNode
        spark.position = node.position
        spark.particleColorSequence = nil
        spark.particleColorBlendFactor = 1.0
        
        switch id {
        case BallType.BLUE.rawValue:
            spark.particleColor = colorUtils.blue
            break
        case BallType.GREEN.rawValue:
            spark.particleColor = colorUtils.green
            break
        case BallType.ORANGE.rawValue:
            spark.particleColor = colorUtils.orange
            break
        case BallType.RED.rawValue:
            spark.particleColor = colorUtils.red
            break
        default:
            break
        }
        
        spark.setScale(0.5)
        self.addChild(spark)
        
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        spark.runAction(sequence)
    
        node.removeFromParent()
    }
    
}
