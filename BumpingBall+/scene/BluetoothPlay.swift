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

class BluetoothPlay: BaseScene {
    
    let headerViewMatch = HeaderViewMatch()
    var myLifeCount = 3
    var partnerLifeCount = 3
    var sceneVC: UIViewController!
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white)
    var loadingBkView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT))
    var bluetoothUtil: BluetoothUtil! = nil

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.view?.addSubview(headerViewMatch)
        
        DispatchQueue.main.async(execute: { //viewロードの整合を保ちます.
            self.bluetoothUtil = BluetoothUtil(scene: self)
            self.bluetoothUtil.setupSession()
            self.bluetoothUtil.setupLoadingComponent()
        })
    }
    
    func sessionConnected() {
        self.countdownView.start()
    }
    
    override func tballComesInTouchArea(_ node: SKSpriteNode) {
        if myLifeCount < 1 {
            return
        }
        node.removeFromParent()
        headerViewMatch.disapperAnimation(PlayerType.player1, life: myLifeCount)
        sendLifeData(myLifeCount)
        myLifeCount -= 1
        if myLifeCount < 1 {
            self.isFin = true
            self.finish()
        }
    }
    
    func sendPauseData() {
        let dic: [String : AnyObject] = ["isPaused": self.isPaused as AnyObject]
        bluetoothUtil.sendData(dic: dic)
    }
    
    func sendLifeData(_ lifeCount: Int) {
        let dic: [String : AnyObject] = ["lifeCount": lifeCount as AnyObject]
        bluetoothUtil.sendData(dic: dic)
    }
    
    func receiveData(data: [String: AnyObject]) {
        
        if let data = data["lifeCount"] {
            let lifeCount = data as! Int
            self.headerViewMatch.disapperAnimation(PlayerType.player2, life: lifeCount)
        }
        
        if let data = data["isPaused"] {
            let isPaused = data as! Bool
            if isPaused {
                
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
