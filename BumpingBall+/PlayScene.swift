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
    let util = Utils()
    let ballUtil = BallUtils()
    var last: CFTimeInterval!
    
    // 当たり判定のカテゴリを準備する.
    let ballCategory: UInt32 = 0x1 << 0
    let targetBallCategory: UInt32 = 0x1 << 1
    
    override func didMoveToView(view: SKView) {
        //ここは物理世界.
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor.blackColor()
    
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "score"
        myLabel.fontSize = 30
        myLabel.fontColor = UIColor.whiteColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-30)
        self.addChild(myLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            ball = Ball()
            ball.ball.name = "ball"
            ball.ball.position.x = location.x
            ball.ball.position.y = location.y + define.TOUCH_MARGIN
            ball.ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.ball.size.width / 2.0)
            ball.ball.physicsBody?.affectedByGravity = false
            ball.ball.physicsBody?.categoryBitMask = ballCategory
            ball.ball.physicsBody?.contactTestBitMask = targetBallCategory
            
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
        let actionMove = SKAction.moveToY(util.HEIGHT, duration: Double(ball.ballSpeed))
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
            createTargetBall()
            last = currentTime
        }
    }
    
    private func removeBall() {
        self.enumerateChildNodesWithName("ball", usingBlock: {
            node, step in
            if node is SKSpriteNode {
                let ball = node as! SKSpriteNode
//                print("posY : ", ball.position.y, ", height : ", self.util.HEIGHT)
                //物理演算を取り入れると0.1足りなくなるので
                if ball.position.y >= self.util.HEIGHT-1 {
                    ball.runAction(SKAction.fadeOutWithDuration(0.3), completion: {
                        ball.removeFromParent()
                    })
                }
            }
        })
    }
    
    private func sizeChange() {
        ball.ballScale += 0.015
        if ball.ballScale < 0.7 {
            ball.ballSpeed = define.BALL_INIT_SPEED
            ball.ball.runAction(ballUtil.setBlue())
        } else if ball.ballScale < 0.9 {
            ball.ballSpeed = 0.75
            ball.ball.runAction(ballUtil.setGreen())
        } else if ball.ballScale < 1.1 {
            ball.ballSpeed = 1.0
            ball.ball.runAction(ballUtil.setOrange())
        } else if ball.ballScale < 1.3 {
            ball.ballSpeed = 1.25
            ball.ball.runAction(ballUtil.setRed())
        } else {
            ball.ballScale = define.BALL_INIT_SCALE
            ball.ballSpeed = define.BALL_INIT_SPEED
        }
        ball.ball.setScale(ball.ballScale)
    }
    
    private func createTargetBall() {
        targetBall = TargetBall()
        targetBall.ball.name = "t_ball"
        targetBall.ball.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-50)
        targetBall.ball.physicsBody = SKPhysicsBody(circleOfRadius: targetBall.ball.size.width / 2.0)
        targetBall.ball.alpha = 0.0
        targetBall.ball.physicsBody?.affectedByGravity = true
        targetBall.ball.physicsBody?.categoryBitMask = targetBallCategory
        targetBall.ball.physicsBody?.contactTestBitMask = ballCategory
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
        
        // ballとtargetballが接触した時の処理
        if firstBody.categoryBitMask & ballCategory != 0 &&
            secondBody.categoryBitMask & targetBallCategory != 0 {
                firstBody.node?.removeFromParent()
                secondBody.node?.removeFromParent()
        }
    }
    
}
