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

class BluetoothPlay: BaseScene, MCSessionDelegate, MCAdvertiserAssistantDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    let headerViewMatch = HeaderViewMatch()
    var myLifeCount = 3
    var partnerLifeCount = 3
    var sceneVC: UIViewController!
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white)
    var loadingBkView = UIView(frame: CGRect(x: 0, y: 0, width: define.WIDTH, height: define.HEIGHT))

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.view?.addSubview(headerViewMatch)
        
        DispatchQueue.main.async(execute: { //viewロードの整合を保ちます.
            self.setupSession()
            self.setupLoadingComponent()
        })
    }
    
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
    
    func setupSession() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID)
        session.delegate = self
        
        advertiser = MCAdvertiserAssistant(serviceType: "bbplus2016", discoveryInfo: nil, session: session)
        advertiser?.delegate = self
        advertiser?.start()
        
        browser = MCBrowserViewController(serviceType: "bbplus2016", session: session)
        browser.delegate = self
        sceneVC = Util.getForegroundViewController()
        sceneVC.present(browser, animated: true, completion: nil)
    }
    
    func setupLoadingComponent() {
        loadingBkView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        loadingView.center = define.CENTER
        loadingBkView.addSubview(self.loadingView)
    }
    
    func hideLoadingComponent() {
        loadingBkView.alpha = 0.0
        loadingView.alpha = 0.0
        loadingView.stopAnimating()
    }
    func showLoadingComponent() {
        loadingBkView.alpha = 0.8
        loadingView.alpha = 1.0
        loadingView.startAnimating()
    }
    
//    func sendData() {
//        if session.connectedPeers.count > 0 {
//            do {
//                let data = tf.text?.dataUsingEncoding(NSUTF8StringEncoding)
//                try session.sendData(data!, toPeers: session.connectedPeers, withMode: .Reliable)
//            } catch let error as NSError {
//                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .Alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            }
//        }
//    }
    
    
    func sendPauseData() {
        do {
            let dic: Dictionary = ["isPaused": self.isPaused]
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: dic)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch _ as NSError {
            print("sendPauseData failed")
        }
    }
    
    func sendLifeData(_ lifeCount: Int) {
        do {
            let dic: Dictionary = ["lifeCount": lifeCount]
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: dic)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch _ as NSError {
            print("sendLifeData failed")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dataObj = NSKeyedUnarchiver.unarchiveObject(with: data)! as AnyObject
        let dataDic = dataObj as! Dictionary<String, AnyObject>
        //※point!!（非同期なのでpromiseで認知してあげる必要がある.）
        DispatchQueue.main.async {
                print("data : \(data)")
            let lifeCount = dataDic["lifeCount"] as! Int
            self.headerViewMatch.disapperAnimation(PlayerType.player2, life: lifeCount)
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async(execute: {
                self.headerViewMatch.playerLabel1.text = UIDevice.current.name
                self.headerViewMatch.playerLabel2.text = peerID.displayName
                self.hideLoadingComponent()
                self.browser.dismiss(animated: true, completion: nil)
                self.countdownView.start()
            })
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.showLoadingComponent()
                self.browser.view.addSubview(self.loadingBkView)
            }
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.hideLoadingComponent()
                let alert: UIAlertController = UIAlertController(title: "接続失敗", message: "再度デバイスを選択して下さい", preferredStyle:  UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                self.browser.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        hideLoadingComponent()
        browser.dismiss(animated: true, completion: nil)
        sceneVC.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        hideLoadingComponent()
        browser.dismiss(animated: true, completion: nil)
        sceneVC.dismiss(animated: true, completion: nil)
    }
    
}
