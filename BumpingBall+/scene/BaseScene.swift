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
    let ballUtil = BallUtil()
    let animation = Animation()
    let themeUtil = ThemeUtil()
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
    var timer: CFTimeInterval!
    var timecounter = 0
    var level = Level()
    let btnSelectSound = Sound.prepareToPlay(Sound.buttonLevelSelect)
    let ud = UserDefaults.standard
    
    // 当たり判定のカテゴリを準備する.
    let ballCategory: UInt32 = 0x1 << 0
    let targetBallCategory: UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        // ここは物理世界.
        self.physicsWorld.contactDelegate   = self
        self.physicsWorld.speed = CGFloat(1.0)
        setBackgroundColor()
        
        //set background
        if app.selectedDiffculty != .tutorial {
            let themestr = themeUtil.getThemeString(themeType: app.theme)
            let background = themeUtil.getBackground(theme: themestr)
            let backgroundAnimation = themeUtil.getBackgroundAnimation(theme: themestr)
            self.addChild(background)
            self.addChild(backgroundAnimation)
        }
        
        app.score = 0
        
        // set touch enable area
        self.addChild(touchView)
        self.view?.addSubview(touchViewTxt)
        self.view?.addSubview(countdownView)
        self.addChild(charge)
        finishView.setupAd() //表示にディレイが起きないよう広告をはじめに読み込んでおきます.
    }
    
    func setBackgroundColor() {
        self.backgroundColor = UIColor.black
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
            if !inTouch {
                return
            }
            playerBall.ball.position.x = location.x
            playerBall.ball.position.y = location.y + define.TOUCH_MARGIN
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var isGold = false
        for touche in touches {
            let location = touche.location(in: self)
            let swipe = location.y > touchBeginLocation.y && location.y > touchView.frame.height
            if swipe && charge.isFull {
                isGold = true
                playerBall.setGold()
                chargeReset()
                Sound.play(node: playerBall.ball, action: Sound.launchGold)
                let action = animation.goldenModeBk()
                self.run(action, withKey: "goldBk")
            }
        }
        
        if !inTouch {
            return
        }
        if !isGold {
            Sound.play(node: playerBall.ball, action: Sound.launch)
        }
        playerBall.isFire = true
        playerBall.setIsFire()
        let actionMove = SKAction.moveTo(y: define.REMOVE_HEIGHT, duration: Double(playerBall.ballSpeed))
        playerBall.ball.run(actionMove)
        launchAnimation()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if !isStart {
            if app.isStart != nil && app.isStart! {
                isStart = true
                level.updateParam()
                print("start!!")
                showStageSign()
            }
            return
        }
        
        if last == nil {
            createTargetBall()
            last = currentTime
            timer = currentTime
        }
        
        if timer + 1.0 <= currentTime {
            if app.level >= define.LEVEL_MAX || isFin {
                timer = currentTime
                return
            }
            timecounter += 1
            if timecounter % define.LEVEL_UP_INTERVAL == 0 {
                app.level += 1
                level.updateParam()
                showStageSign()
            }
            timer = currentTime
        }
        
        if last + app.interval <= currentTime {
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
                            self.setBackgroundColor()
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
        let targetBall = TargetBall()
        var posX: UInt! = UInt(arc4random_uniform(UInt32(CGFloat.WIDTH)))
        posX = targetBall.setInScreen(posX)
        
        targetBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        targetBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(targetBall.ball)
        targetBall.ball.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func moveTargetBall(accel: Double) {
        self.enumerateChildNodes(withName: "t_ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let targetBall = node as! SKSpriteNode
                self.ballUtil.setBoundX(targetBall)
                let dx = targetBall.userData?.value(forKey: "dx") as! Double
                let dy = targetBall.userData?.value(forKey: "dy") as! Double
                if dx < 0 {
                    targetBall.position.x += CGFloat(dx - accel)
                } else {
                    targetBall.position.x += CGFloat(dx + accel)
                }
                targetBall.position.y -= CGFloat(dy + accel)
                
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
        Sound.play(node: self, action: Sound.bomb)
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
        
        guard let mix = secondBody.node?.userData?.value(forKey: "mix") as? Bool else {
            return
        }
        let isMixBlue = (mix && myId as! Int == BallType.blue.rawValue)
        
        if !playerBall.isGold(firstBody.node!) {
            if !isSame && !isMixBlue {
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
            Sound.play(node: self, action: Sound.collision)
            return
        }
        //        最大で5コンボ
        if comboCount > MAX_COMBO_COUNT {
            comboCount = MAX_COMBO_COUNT + 1
            Sound.play(node: self, action: Sound.collision_perfect)
        } else {
            Sound.play(node: self, action: Sound.collision)
        }
        
        let count = comboCount - 1
        let comboNode = SKSpriteNode(imageNamed: "combo_\(count)")
        comboNode.position = CGFloat.CENTER
        self.addChild(comboNode)
        let moveFadeOut = animation.moveToYFadeOut(0.7, yPos: CGFloat.CENTER.y + CGFloat(30.0), moveToY: 0.5)
        let sequence = animation.removeAfterAction(moveFadeOut)
        comboNode.run(sequence)
        
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
        let pos = CGPoint(x: node.position.x, y: node.position.y)
        let launchNode = animation.launchNode(pos, id: id)
        self.addChild(launchNode)
        let launch = animation.destroyAnimation()
        launchNode.run(launch)
        node.removeFromParent()
    }
    
    func changeTargetBall(_ pBall: SKNode, tBall: SKNode, id: Int) {
        let pos = CGPoint(x: pBall.position.x, y: pBall.position.y)
        let launchNode = animation.launchNode(pos, id: id)
        launchNode.xScale = 0.5
        launchNode.yScale = 0.5
        self.addChild(launchNode)
        let launch = animation.absorptionAnimation()
        launchNode.run(launch)
        
        let num = tBall.userData?.value(forKey: "num") as! Int
        let resNum = num - 1
        tBall.userData?.setValue(resNum, forKey: "num")
        
        let mix = tBall.userData?.value(forKey: "mix") as! Bool
        var action: SKAction! = nil
        if mix {
            let pBallId = pBall.userData?.value(forKey: "id") as! Int
            action = ballUtil.getBallImageForMix(pBallId, targetBall: tBall)
        } else {
            action = ballUtil.getBallImageByNum(id, num: resNum)
        }
        let scaleAnimation = animation.scaleAnimation(tBall)
        let group = SKAction.group([action, scaleAnimation])
        tBall.run(group)
    }
    
    func launchAnimation() {
        guard let id = playerBall.ball.userData?.value(forKey: "id") as? Int else {
            return
        }
        if playerBall.isGold(playerBall.ball) {
            return
        }
        let point = CGPoint(x: playerBall.ball.position.x, y: playerBall.ball.position.y)
        let node = animation.launchNode(point, id: id)
        self.addChild(node)
        let action = animation.launchAnimation()
        node.run(action)
    }
    
    //  ゲームオーバー処理
    func finish() {
        self.isUserInteractionEnabled = false
        finishView.setup()
        finishView.setScoreLabel(score)
        finishView.setLevelLabel()
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
    
    func showStageSign() {
        if app.selectedDiffculty == .tutorial {
            return
        }
        Sound.play(audioPlayer: btnSelectSound)
        let stageSign = StageSign(frame: CGRect(x: 0, y: 0, width: CGFloat.HEIGHT, height: define.STAGE_SIGN_HEIGHT))
        stageSign.center = CGFloat.CENTER
        stageSign.setNumber(level: app.level)
        self.view?.addSubview(stageSign)
    }
    
    func playSceneBgm() {
        Bgm.playBgm(filename: Bgm.playMusic)
    }
}
