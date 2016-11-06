//
//  BaseScene.swifr
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright (c) 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit
import UIKit

class BaseScene: SKScene, SKPhysicsContactDelegate {
    
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var playerBall = PlayerBall()
    var targetBall = TargetBall()
    let ballUtil = BallUtil()
    let animation = Animation()
    let difficulty = Difficulty()
    var last: CFTimeInterval!
    var score = 0
    var comboCount = 0
    var touchBeginLocation = CGPoint()
    let finishView = FinishView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT))
    let countdownView = CountdownView()
    let touchViewTxt = TouchViewTxt()
    var touchView = TouchView()
    var isStart = false
    var isFin = false
    let MAX_COMBO_COUNT = 5
    let charge = ChargeMeter()
    private var inTouch = false
    
    // 当たり判定のカテゴリを準備する.
    let ballCategory: UInt32 = 0x1 << 0
    let targetBallCategory: UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        // ここは物理世界.
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = CGFloat(1.0)
        self.backgroundColor = UIColor.black
        
        app.score = 0
        
        // set touch enable area
        self.addChild(touchView)
        self.view?.addSubview(touchViewTxt)
        self.view?.addSubview(countdownView)
        self.addChild(charge)
        
        // set background animation.
        let snow = animation.backgroundAnimation()
        self.addChild(snow)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let disabled = self.isPaused || !isStart || isFin //ポーズ中は入力出来ないように.
        if disabled {
            return
        }
        
        for touch in touches {
            //            print(touch.locationInView(self.view))
            
            touchBeginLocation = touch.location(in: self)
            
            if !(define.TOUCH_AREA.contains(touchBeginLocation)) {
                inTouch = false
                return
            }
            inTouch = true
            createPlayerBall(touchBeginLocation)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche in touches {
            let location = touche.location(in: self)
            if !(define.TOUCH_AREA.contains(location)) {
                return
            }
            playerBall.ball.position.x = location.x
            playerBall.ball.position.y = location.y + define.TOUCH_MARGIN
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        ball.ball.runAction(Sound.launch)
        for touche in touches {
            let location = touche.location(in: self)
            let swipe = location.y < touchBeginLocation.y && location.y < 10
            if swipe && charge.isFull {
                playerBall.setGold()
                chargeReset()
                let action = animation.goldenModeBk()
                self.run(action, withKey: "goldBk")
            }
        }
        if !inTouch {
            return
        }
        playerBall.isFire = true
        playerBall.setIsFire()
        let actionMove = SKAction.moveTo(y: define.REMOVE_HEIGHT, duration: Double(playerBall.ballSpeed))
        playerBall.ball.run(actionMove)
        launchAnimation()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isStart {
            if app.isStart != nil && app.isStart! {
                isStart = true
            }
            return
        }
        
        if last == nil {
            createTargetBall()
            last = currentTime
        }
        
        if last + difficulty.getInterval() <= currentTime {
            print("getInterval : \(difficulty.getInterval())")
            createTargetBall()
            last = currentTime
        }
        removeBall()
    }
    
    fileprivate func removeBall() {
        self.enumerateChildNodes(withName: "ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let ball = node as! SKSpriteNode
                //                物理演算を取り入れると0.1足りなくなるので
                if ball.position.y >= define.REMOVE_HEIGHT-1 {
                    ball.run(SKAction.fadeOut(withDuration: 0.3), completion: {
                        ball.removeFromParent()
                        if !self.playerBall.isGold(node) {
                            self.comboCount = 0
                        } else {
                            self.removeAction(forKey: "goldBk")
                            self.backgroundColor = UIColor.black
                        }
                    })
                }
            }
        })
    }
    
    func createPlayerBall(_ touchPoint: CGPoint) {
        playerBall = PlayerBall()
        playerBall.setLocation(touchPoint.x, posY: touchPoint.y + define.TOUCH_MARGIN)
        playerBall.setCategory(ballCategory, targetCat: targetBallCategory)
        self.addChild(playerBall.ball)
    }
    
    func createTargetBall() {
        targetBall = TargetBall()
        var posX: UInt! = UInt(arc4random_uniform(UInt32(CGFloat.WIDTH)))
        posX = targetBall.setInScreen(posX)
        
        targetBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        targetBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(self.targetBall.ball)
        targetBall.ball.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func moveTargetBall(accel: CGFloat) {
        self.enumerateChildNodes(withName: "t_ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let targetBall = node as! SKSpriteNode
                self.ballUtil.setBoundX(targetBall)
                let dx = targetBall.userData?.value(forKey: "dx") as! CGFloat
                let dy = targetBall.userData?.value(forKey: "dy") as! CGFloat
                if dx < 0 {
                    targetBall.position.x += (dx - accel)
                } else {
                    targetBall.position.x += (dx + accel)
                }
                targetBall.position.y -= (dy + accel)
                
                if self.isFin {
                    return
                }
                
                //              自陣にボールが入るとゲームオーバーになります.
                if define.TOUCH_AREA.contains(targetBall.position) {
                    self.tballComesInTouchArea(targetBall)
                }
            }
        })
    }
    
    //自陣にボールが入った処理(oneplayとmultiplayで分岐します)
    func tballComesInTouchArea(_ node: SKSpriteNode) {
        var id = node.userData?.value(forKey: "id") as? Int
        if id == nil {
            id = 0
        }
        let spark = animation.sparkAnimation(node, id: id!, scale: 1.0)
        self.addChild(spark)
        let sequence = animation.fadeOutRemove(1.0)
        spark.run(sequence)
        node.removeFromParent()
    }
    
    
    //  衝突したときの処理.
    func didBegin(_ contact: SKPhysicsContact) {
        
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
        let isFire = firstBody.node?.userData?.value(forKey: "isFire")
        if isFire == nil || !(isFire as! Bool) {
            return
        }
        
        let num = secondBody.node?.userData?.value(forKey: "num")
        if num == nil {
            return
        }
        
        let myId = firstBody.node?.userData?.value(forKey: "id")
        let targetId = secondBody.node?.userData?.value(forKey: "id")
        
        let isNull = (myId == nil || targetId == nil)
        if isNull {
            return
        }
        
        let tId = targetId as! Int
        let isSame =  (myId as! Int == tId)
        
        if !playerBall.isGold(firstBody.node!) {
            if !isSame {
                return
            }
        }
        
        let collisionCorrect = (firstBody.categoryBitMask & ballCategory != 0 && secondBody.categoryBitMask & targetBallCategory != 0)
        if collisionCorrect {
            collision(firstBody.node!, secondNode: secondBody.node!, targetId: tId)
            removePlayerBall(firstBody: firstBody.node!)
        }
    }
    
    func removePlayerBall(firstBody: SKNode) {
        if !playerBall.isGold(firstBody) {
            firstBody.removeFromParent()
        }
    }
    
    func collision(_ firstNode: SKNode, secondNode: SKNode, targetId: Int) {
//        do collision something..
    }
    
    func collisionToSpecialItemBall(_ firstNode: SKNode, secondNode: SKNode, targetId: Int) {
//        do collision to special item ball something..
    }
    
    
    func updateComboCount(_ pnode: SKNode, tnode: SKNode) {
        comboCount += 1
        
        if comboCount == 1 {
            return
        }
        //        最大で5コンボ
        if comboCount > (MAX_COMBO_COUNT + 1) {
            comboCount = MAX_COMBO_COUNT + 1
        }
        
        let comboLabel = SKLabelNode(fontNamed:"ChalkboardSE-Regular")
        comboLabel.text = "combo×"+String(comboCount-1)
        comboLabel.fontColor = UIColor.red
        comboLabel.fontSize = 20
        comboLabel.position = tnode.position
        self.addChild(comboLabel)
        
        let moveFadeOut = animation.moveToYFadeOut(0.8, yPos: tnode.position.y + 30, moveToY: 0.5)
        let sequence = animation.removeAfterAction(moveFadeOut)
        comboLabel.run(sequence)
        
        let prevCharge = charge.isFull //fullになった時のみを取得するため
        if !playerBall.isGold(pnode) {
            charge.update(comboCount)
        }
        
        if !prevCharge && charge.isFull {
            chargeFull()
        }
    }
    
    func updateScore() {
        score += ballUtil.getScoreByCombo(comboCount)
        app.score = score
    }
    
    func removeTargetBall(_ node: SKNode, id: Int) {
        let spark = animation.sparkAnimation(node, id: id, scale: 0.5)
        self.addChild(spark)
        let sequence = animation.fadeOutRemove(0.5)
        spark.run(sequence)
        node.removeFromParent()
    }
    
    func changeTargetBall(_ pBall: SKNode, tBall: SKNode, id: Int) {
        let spark = animation.sparkAnimation(pBall, id: id, scale: 0.2)
        self.addChild(spark)
        let sequence = animation.fadeOutRemove(0.5)
        spark.run(sequence)
        
        let num = tBall.userData?.value(forKey: "num") as! Int
        let resNum = num - 1
        tBall.userData?.setValue(resNum, forKey: "num")
        let action = ballUtil.getBallImageByNum(id, num: resNum)
        let scaleAnimation = animation.scaleAnimation(tBall)
        let group = SKAction.group([action, scaleAnimation])
        tBall.run(group)
    }
    
    func launchAnimation() {
        if playerBall.ball.userData?.value(forKey: "id") == nil {
            return
        }
        let id = playerBall.ball.userData?.value(forKey: "id") as! Int
        let launch = animation.launchAnimation(playerBall.ball, id: id)
        self.addChild(launch)
        
        let moveFadeOut = animation.moveToYFadeOut(0.5, yPos: playerBall.ball.position.y - 20.0, moveToY: 0.5)
        let sequence = animation.removeAfterAction(moveFadeOut)
        launch.run(sequence)
    }
    
    //  ゲームオーバー処理
    func finish() {
        self.isUserInteractionEnabled = false
        finishView.setup()
        finishView.setScoreLabel(score)
        finishView.alpha = 0.0
        self.view!.addSubview(finishView)
        
        UIView.animate(withDuration: 1, animations: {
            self.finishView.alpha = 1.0
            }, completion: { finished in
        })
    }
    
    func chargeFull() {
        touchView.chargeFull()
        touchViewTxt.chargeFull()
    }
    
    func chargeReset() {
        charge.reset()
        touchView.removeFromParent()//skspritenodeのcolorをデフォルトに戻すため再生成.
        touchView = TouchView()
        self.addChild(touchView)
        touchViewTxt.chargeReset()
    }
    
}
