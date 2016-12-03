//
//  BluetoothPlay.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity
import NVActivityIndicatorView
import SCLAlertView

class BluetoothPlay: BaseScene {
    
    let headerViewMatch = HeaderViewMatch()
    let prepareView = PrepareView()
    var waitingView = WaitingView()
    var itemBall = ItemBall()
    var myLifeCount = 3
    var partnerLifeCount = 3
    var scenevc: SceneViewController!
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white)
    var loadingBkView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT))
    var bluetoothUtil: BluetoothUtil! = nil
    var selfPrepared = false
    var partnerPrepared = false
    var isReverse = false
    var isSpecialMode = false
    var accel: Double = 0.0
    var secTimer: CFTimeInterval!
    var specialModeTimer = define.SPECIAL_MODE_TIME
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.view?.addSubview(headerViewMatch)
        self.view?.addSubview(prepareView)
        self.view?.addSubview(waitingView)
        
        DispatchQueue.main.async(execute: { //viewロードの整合を保ちます.
            self.bluetoothUtil = BluetoothUtil(scene: self)
            self.bluetoothUtil.setupSession()
            self.bluetoothUtil.setupLoadingComponent()
        })
    }
    
    func sessionConnected() {
        selfPrepared = true
        let dic: [String : AnyObject] = ["prepared": true as AnyObject]
        bluetoothUtil.sendData(dic: dic)
        waitingView.show()
        start()
    }
    
    func start() {
        if selfPrepared && partnerPrepared {
            waitingView.hide()
            prepareView.removeFromSuperview()
            playSceneBgm()
            self.countdownView.start()
        }
    }
    
    override func tballComesInTouchArea(_ node: SKSpriteNode) {
        super.tballComesInTouchArea(node)
        if myLifeCount < 1 {
            return
        }
        node.removeFromParent()
        headerViewMatch.disappearAnimation(PlayerType.player1, life: myLifeCount)
        myLifeCount -= 1
        sendLifeData(myLifeCount)
        if myLifeCount < 1 {
            self.isFin = true
            self.finish()
            self.finishView.mainLabel.text = "LOSE.."
            self.finishView.mainLabel.textColor = ColorUtil.loseColor
        }
    }
    
    func sendPauseData(type: PauseType) {
        let dic: [String : AnyObject] = ["pause": type.rawValue as AnyObject]
        bluetoothUtil.sendData(dic: dic)
    }
    
    func sendLifeData(_ lifeCount: Int) {
        let dic: [String : AnyObject] = ["lifeCount": lifeCount as AnyObject]
        bluetoothUtil.sendData(dic: dic)
    }
    
    func sendBallData(_ id: Int) {
        let dic: [String : AnyObject] = ["targetBallId": id as AnyObject]
        bluetoothUtil.sendData(dic: dic)
    }
    
    func receiveData(data: [String: AnyObject]) {
        
        if let data = data["targetBallId"] {
            let id = data as! Int
            let ballType = BallType(rawValue: id)! as BallType
            if ballType.isSpecialItemBall() {
                specialItemAction(type: ballType)
            } else {
                createDevilBall(id: id)
            }
        }
        
        if let data = data["prepared"] {
            partnerPrepared = data as! Bool
            if partnerPrepared {
                prepareView.waitingLabel.isHidden = false
                start()
            }
        }
        
        if let data = data["lifeCount"] {
            let lifeCount = data as! Int
            partnerLifeCount = lifeCount
            self.headerViewMatch.disappearAnimation(PlayerType.player2, life: lifeCount + 1)
            if lifeCount < 1 {
                self.isFin = true
                self.finish()
                self.finishView.mainLabel.text = "WIN!!"
                self.finishView.mainLabel.textColor = ColorUtil.winColor
            }
        }
        
        if let data = data["pause"] {
            let pause = PauseType(rawValue: data as! Int)
            switch pause! {
            case .pause:
                self.isPaused = true
                waitingView.txt.text = "Pausing.."
                waitingView.show()
                break
            case .resume:
                self.isPaused = false
                waitingView.hide()
                break
            case .quit:
                if app.bluetoothSession != nil {
                    app.bluetoothSession?.disconnect()
                }
                break
            default:
                break
            }
        }
    }
    
    /** Common functions. **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override func createPlayerBall(_ touchPoint: CGPoint) {
        super.createPlayerBall(touchPoint)
        if isReverse {
            playerBall.ballScale = define.BALL_MAX_SCALE
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if  !playerBall.isFire {
            playerBall.sizeChange(reverse: isReverse)
        }
        
        if self["item_ball"].count > 0 {
            moveItemBall()
        }
        moveTargetBall(accel: accel)
        
        if secTimer == nil {
            secTimer = currentTime
        }
        
        //1秒おき
        if secTimer + 1.0 <= currentTime {
            if self["item_ball"].count > 0 {
                manageItemBallTimer()
            }
            if isSpecialMode {
                manageSpecialModeTimer()
            }
            secTimer = currentTime
        }
    }
    
    override func collision(_ firstNode: SKNode, secondNode: SKNode, targetId: Int) {
        let num = secondNode.userData?.value(forKey: "num") as! Int
        let canRemove = (num == 1 || playerBall.isGold(firstNode))
        if canRemove {
            if let isItem = secondNode.userData?.value(forKey: "isItem") as? Bool {
                let targetIdType = BallType(rawValue: targetId)! as BallType
                if isItem {
                    let isOk = (targetIdType.isSpecialItemBall() && playerBall.isGold(firstNode)) || (!targetIdType.isSpecialItemBall() && !playerBall.isGold(firstNode))
                    if isOk {
                        secondNode.userData?.setValue(true, forKey: "isCollision")
                        launchItemBall(secondNode, id: targetId)
                        sendBallData(targetId)
                        let type = BallType(rawValue: targetId)! as BallType
                        if type == .oneup && myLifeCount < 3 {
                            myLifeCount += 1
                            headerViewMatch.appearAnimation(PlayerType.player1, life: myLifeCount)
                        }
                    }
                }
            } else {
                // normal ball.
                updateComboCount(firstNode, tnode: secondNode)
                removeTargetBall(secondNode, id: targetId)
                updateScore()
                
                // 「コンボ3以上」かつ「itemballが5つ以下」でitem ballが生成されます.
                let itemBallCount = self["item_ball"].count
                let canCreateItemBall = comboCount > define.COMBO_FOR_ITEM_BALL && itemBallCount < define.MAX_ITEM_BALL
                if canCreateItemBall {
                    createItemBall()
                }
            }
        } else {
            self.run(Sound.collisionNotRemove)
            changeTargetBall(firstNode, tBall: secondNode, id: targetId)
        }
    }
    
    fileprivate func createItemBall() {
        itemBall = ItemBall()
        let rand = Int(arc4random_uniform(4))
        let canCreateSpecialItem =  (rand == 0 && !existSpecialItemBall())
        if canCreateSpecialItem {
            itemBall.changeSpecialItemBall()
        }
        var posX: UInt! = UInt(arc4random_uniform(UInt32(CGFloat.WIDTH)))
        posX = itemBall.setInScreen(posX)
        itemBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        itemBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(itemBall.ball)
        itemBall.ball.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func moveItemBall() {
        self.enumerateChildNodes(withName: "item_ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let node = node as! SKSpriteNode
                guard let isCollision = node.userData?.value(forKey: "isCollision") as? Bool else {
                    return
                }
                if !isCollision {
                    self.ballUtil.setBoundX(node)
                    self.ballUtil.setBoundY(node)
                    let dx = node.userData?.value(forKey: "dx") as! Double
                    let dy = node.userData?.value(forKey: "dy") as! Double
                    node.position.x += CGFloat(dx)
                    node.position.y -= CGFloat(dy)
                }
            }
        })
    }
    
    func existSpecialItemBall() -> Bool {
        var isExist = false
        self.enumerateChildNodes(withName: "item_ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let node = node as! SKSpriteNode
                if let isSpecial = node.userData?.value(forKey: "isSpecial") as? Bool {
                    if isSpecial {
                        isExist = true
                    }
                }
            }
        })
        return isExist
    }
    
    func launchItemBall(_ node: SKNode, id: Int) {
        node.alpha = 1.0
        node.removeAction(forKey: "blink")
        
        let spark = animation.sparkAnimation(node, id: id, scale: 0.25)
        self.addChild(spark)
        let sequence = animation.fadeOutRemove(0.5)
        spark.run(sequence)
        
        let actionMove = animation.itemBallLaunchAnimation(node)
        let s = animation.removeAfterAction(actionMove)
        node.run(s)
    }
    
//    item ballが存在できる時間を管理します.
    func manageItemBallTimer() {
        self.enumerateChildNodes(withName: "item_ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let node = node as! SKSpriteNode
                if var timer = node.userData?.value(forKey: "timer") as? Int {
                    if timer <= 1 {
                        node.removeAllActions()
                        node.removeFromParent()
                        return
                    }
                    if timer == 5 {
                        let blink = self.animation.blinkAnimation(node)
                        let forever = SKAction.repeatForever(blink)
                        node.run(forever, withKey: "blink")
                    }
                    timer -= 1
                    node.userData?.setValue(timer, forKey: "timer")
                }
            }
        })
    }
    
//    reverse・speedupを受ける時間を管理します.
    func manageSpecialModeTimer() {
        self.enumerateChildNodes(withName: "specialItemIcon", using: {
            node, stop in
            if node is SKSpriteNode {
                let node = node as! SKSpriteNode
                if self.specialModeTimer <= 1 {
                    node.removeAllActions()
                    node.removeFromParent()
                    self.isSpecialMode = false
                    self.isReverse = false
                    self.accel = 0.0
                    self.specialModeTimer = define.SPECIAL_MODE_TIME
                    return
                }
                if  self.specialModeTimer == 5 {
                    let blink = self.animation.blinkAnimation(node)
                    let forever = SKAction.repeatForever(blink)
                    node.run(forever, withKey: "blink")
                }
                self.specialModeTimer -= 1
            }
        })
    }
    
    fileprivate func createDevilBall(id: Int) {
        let targetBall = TargetBall()
        targetBall.changeDevilBall(id: id)
        var posX: UInt! = UInt(arc4random_uniform(UInt32(CGFloat.WIDTH)))
        posX = targetBall.setInScreen(posX)
        targetBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        targetBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(targetBall.ball)
        targetBall.ball.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func specialItemAction(type: BallType) {
        switch type {
        case .reverse:
            print("reverse")
            isSpecialMode = true
            isReverse = true
            showSpecialItemIcon(imagename: "reverse_bk")
            break
        case .speedup:
            print("speedup")
            isSpecialMode = true
            accel = 0.5
            showSpecialItemIcon(imagename: "speedup_bk")
            break
        case .oneup:
            print("oneup")
            partnerLifeCount += 1
            headerViewMatch.appearAnimation(PlayerType.player2, life: partnerLifeCount)
            break
        default:
            break
        }
    }
    
    func showSpecialItemIcon(imagename: String) {
        let node = SKSpriteNode(imageNamed: imagename)
        node.position = CGFloat.CENTER
        node.size = CGSize(width: 200, height: 200)
        node.alpha = 0.5
        node.name = "specialItemIcon"
        self.addChild(node)
        let scaleAction = animation.scaleAnimation(node)
        let forever = SKAction.repeatForever(scaleAction)
        node.run(forever)
    }
    
}
