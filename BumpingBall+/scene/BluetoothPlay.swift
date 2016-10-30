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
    
    func receiveData(data: [String: AnyObject]) {
        
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
    }

}
