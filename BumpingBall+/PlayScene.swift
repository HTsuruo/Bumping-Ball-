//
//  GameScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright (c) 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit
import UIKit

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var playerBall = PlayerBall()
    var targetBall = TargetBall()
    let ballUtil = BallUtils()
    let animation = Animation()
    var last: CFTimeInterval!
    var touchView = UIView()
    var score = 0
    var scoreLabel = SKLabelNode()
    var comboCount = 0
    var touchBeginLocation = CGPoint()
    
//     当たり判定のカテゴリを準備する.
    let ballCategory: UInt32 = 0x1 << 0
    let targetBallCategory: UInt32 = 0x1 << 1
    
    override func didMoveToView(view: SKView) {
//        ここは物理世界.
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = CGFloat(1.0)
        self.backgroundColor = UIColor.blackColor()
        
        setupLabels()
        
//         set touch enable area
        touchView = UIView(frame: CGRectMake(0, define.HEIGHT-70, define.WIDTH, 70))
        touchView.backgroundColor = UIColor.cyanColor()
        self.view?.addSubview(touchView)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if self.paused {//ポーズ中は入力出来ないように.
            return
        }
        
        for touch in touches {
            touchBeginLocation = touch.locationInNode(self)
            
            if !(define.TOUCH_AREA.contains(touchBeginLocation)) {
                return
            }
            
            /* setup playerBall */
            playerBall = PlayerBall()
            playerBall.setLocation(touchBeginLocation.x, posY: touchBeginLocation.y + define.TOUCH_MARGIN)
            playerBall.setCategory(ballCategory, targetCat: targetBallCategory)
            self.addChild(playerBall.ball)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touche in touches {
            let location = touche.locationInNode(self)
            if !(define.TOUCH_AREA.contains(location)) {
                return
            }
            playerBall.ball.position.x = location.x
            playerBall.ball.position.y = location.y + define.TOUCH_MARGIN
         }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        ball.ball.runAction(Sound.launch)
        for touche in touches {
            let location = touche.locationInNode(self)
            if location.y < touchBeginLocation.y && location.y <= 0.5 {
                playerBall.setGoldBall()
            }
        }
        
        playerBall.isFire = true
        playerBall.setIsFire()
        let actionMove = SKAction.moveToY(define.REMOVE_HEIGHT, duration: Double(playerBall.ballSpeed))
        playerBall.ball.runAction(actionMove)
        launchAnimation()
    }
   
    override func update(currentTime: CFTimeInterval) {
        removeBall()
        if  !playerBall.isFire {
            playerBall.sizeChange()
        }
    
        if last == nil {
            last = currentTime
        }
//         3秒毎にtargetBallを作成する.
        if last + 3 <= currentTime {
            createTargetBall()
            last = currentTime
        }
        moveTargetBall()
    }
    
    private func removeBall() {
        self.enumerateChildNodesWithName("ball", usingBlock: {
            node, stop in
            if node is SKSpriteNode {
                let ball = node as! SKSpriteNode
//                物理演算を取り入れると0.1足りなくなるので
                if ball.position.y >= define.REMOVE_HEIGHT-1 {
                    ball.runAction(SKAction.fadeOutWithDuration(0.3), completion: {
                        ball.removeFromParent()
                        if !self.playerBall.isGold(self.playerBall.ball) {
                            self.comboCount = 0
                        }
                    })
                }
            }
        })
    }
    
    private func createTargetBall() {
        targetBall = TargetBall()
        var posX: UInt! = UInt(arc4random_uniform(UInt32(define.WIDTH)))
        posX = targetBall.setScreenFit(posX)
        
        targetBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        targetBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(self.targetBall.ball)
        targetBall.ball.runAction(SKAction.fadeInWithDuration(0.5))
    }
    
    private func moveTargetBall() {
        self.enumerateChildNodesWithName("t_ball", usingBlock: {
            node, stop in
            if node is SKSpriteNode {
                let targetBall = node as! SKSpriteNode
                self.ballUtil.setRebound(targetBall)
                let dx = targetBall.userData?.valueForKey("dx") as! CGFloat
                let dy = targetBall.userData?.valueForKey("dy") as! CGFloat
                targetBall.position.x += dx
                targetBall.position.y -= dy
            }
        })
    }
    
//  衝突したときの処理.
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody, secondBody: SKPhysicsBody
        
//      first: playerBall, second: targetBallとした.
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
//      消滅させることができるのは発射したボールのみ.
        let isFire = firstBody.node?.userData?.valueForKey("isFire")
        if isFire == nil || !(isFire as! Bool) {
            return
        }
        
        let myId = firstBody.node?.userData?.valueForKey("id")
        let targetId = secondBody.node?.userData?.valueForKey("id")
        
        let isNull = myId == nil || targetId == nil
        let isSame =  myId as! Int == targetId as! Int
        
        if !playerBall.isGold(firstBody.node!) {
            if isNull || !(isSame) {
                return
            }
        }
        
//      ballとtargetballが接触した時の処理
        if targetId != nil {
            if firstBody.categoryBitMask & ballCategory != 0 &&
                secondBody.categoryBitMask & targetBallCategory != 0 {
                    updateComboCount(secondBody.node!)
                    removeBothBalls(secondBody.node!, id: targetId as! Int)
                    if !playerBall.isGold(firstBody.node!) {
                        firstBody.node?.removeFromParent()
                    }
                    updateScore()
            }
        }
    }
    
    func updateComboCount(node: SKNode) {
        comboCount++
        
        if comboCount == 1 {
            return
        }
//        最大で5コンボ
        if comboCount > 6 {
            comboCount = 6
        }
        
        let comboLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
        comboLabel.text = "combo×"+String(comboCount-1)
        comboLabel.fontColor = UIColor.redColor()
        comboLabel.fontSize = 20
        comboLabel.position = node.position
        self.addChild(comboLabel)
        
        let moveFadeOut = animation.moveToYFadeOut(0.8, yPos: node.position.y + 30, moveToY: 0.5)
        let sequence = animation.removeAfterAction(moveFadeOut)
        comboLabel.runAction(sequence)
    }
    
    func updateScore() {
        score += ballUtil.getScoreByCombo(comboCount)
        scoreLabel.text = String(score)
    }
    
    func removeBothBalls(node: SKNode, id: Int) {
        let spark = animation.sparkAnimation(node, id: id)
        self.addChild(spark)
        
        let sequence = animation.fadeOutRemove(0.5)
        spark.runAction(sequence)
        
        node.removeFromParent()
    }
    
    func setupLabels() {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "score"
        myLabel.fontSize = 30
        myLabel.fontColor = UIColor.whiteColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-30)
        self.addChild(myLabel)
        
        scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreLabel.text = "0"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.position = CGPoint(x:define.WIDTH - 100, y:self.frame.height-30)
        self.addChild(scoreLabel)
    }
    
    func launchAnimation() {
        if playerBall.ball.userData?.valueForKey("id") == nil {
            return
        }
        let id = playerBall.ball.userData?.valueForKey("id") as! Int
        let launch = animation.launchAnimation(playerBall.ball, id: id)
        self.addChild(launch)
        
        let moveFadeOut = animation.moveToYFadeOut(0.5, yPos: playerBall.ball.position.y - 20.0, moveToY: 0.5)
        let sequence = animation.removeAfterAction(moveFadeOut)
        launch.runAction(sequence)
    }
    
}
