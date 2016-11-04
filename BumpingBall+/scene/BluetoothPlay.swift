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
            self.countdownView.start()
        }
    }
    
    override func tballComesInTouchArea(_ node: SKSpriteNode) {
        super.tballComesInTouchArea(node)
        if myLifeCount < 1 {
            return
        }
        node.removeFromParent()
        headerViewMatch.disapperAnimation(PlayerType.player1, life: myLifeCount)
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
            createDevilBall(id: id)
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
            self.headerViewMatch.disapperAnimation(PlayerType.player2, life: lifeCount + 1)
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
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if self["item_ball"].count > 0 {
            moveItemBall()
        }
    }
    
    override func collision(firstBody: SKPhysicsBody, secondBody: SKPhysicsBody, targetId: Int, num: Int) {
        let canRemove = (num == 1 || playerBall.isGold(firstBody.node!))
        if firstBody.categoryBitMask & ballCategory != 0 &&
            secondBody.categoryBitMask & targetBallCategory != 0 {
            if canRemove {
                //item ball.
                if let isItem = secondBody.node?.userData?.value(forKey: "isItem") as? Bool {
                    if isItem {
                        secondBody.node?.userData?.setValue(true, forKey: "isCollision")
                        removeItemBall(secondBody.node!, id: targetId)
                        sendBallData(targetId)
                    }
                } else {
                    // normal ball.
                    updateComboCount(firstBody.node!, tnode: secondBody.node!)
                    removeTargetBall(secondBody.node!, id: targetId)
                    updateScore()
                    
                    // combo 3, 4, 5のみitem ballを生成します.
                    let itemBallCount = self["item_ball"].count
                    let canCreateItemBall = comboCount > define.COMBO_FOR_ITEM_BALL && itemBallCount < define.MAX_ITEM_BALL
                    if canCreateItemBall {
                        createItemBall()
                    }
                }
            } else {
                changeTargetBall(firstBody.node!, tBall: secondBody.node!, id: targetId)
            }
            if !playerBall.isGold(firstBody.node!) {
                firstBody.node?.removeFromParent()
            }
        }

    }
    
    fileprivate func createItemBall() {
        itemBall = ItemBall()
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
                    let dx = node.userData?.value(forKey: "dx") as! CGFloat
                    let dy = node.userData?.value(forKey: "dy") as! CGFloat
                    node.position.x += dx
                    node.position.y -= dy
                }
            }
        })
    }
    
    func removeItemBall(_ node: SKNode, id: Int) {
        let spark = animation.sparkAnimation(node, id: id, scale: 0.25)
        self.addChild(spark)
        let sequence = animation.fadeOutRemove(0.5)
        spark.run(sequence)
        
        let actionMove = animation.itemBallLaunchAnimation(node)
        let s = animation.removeAfterAction(actionMove)
        node.run(s)
    }
    
    fileprivate func createDevilBall(id: Int) {
        targetBall = TargetBall()
        targetBall.changeDevilBall(id: id)
        var posX: UInt! = UInt(arc4random_uniform(UInt32(CGFloat.WIDTH)))
        posX = targetBall.setInScreen(posX)
        targetBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        targetBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(self.targetBall.ball)
        targetBall.ball.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
}
