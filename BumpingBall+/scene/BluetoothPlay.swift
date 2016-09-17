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
    var loadingView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100), type: .BallClipRotateMultiple, color: UIColor.whiteColor())
    var loadingBkView = UIView(frame: CGRectMake(0, 0, define.WIDTH, define.HEIGHT))

    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.view?.addSubview(headerViewMatch)
        
        dispatch_async(dispatch_get_main_queue(), { //viewロードの整合を保ちます.
            self.setupSession()
            self.setupLoadingComponent()
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
    }
    
    override func tballComesInTouchArea(node: SKSpriteNode) {
        if myLifeCount < 1 {
            return
        }
        node.removeFromParent()
        headerViewMatch.disapperAnimation(PlayerType.PLAYER1, life: myLifeCount)
        sendLifeData(myLifeCount)
        myLifeCount -= 1
        if myLifeCount < 1 {
            self.isFin = true
            self.finish()
        }
    }
    
    func setupSession() {
        peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        session = MCSession(peer: peerID)
        session.delegate = self
        
        advertiser = MCAdvertiserAssistant(serviceType: "bbplus2016", discoveryInfo: nil, session: session)
        advertiser?.delegate = self
        advertiser?.start()
        
        browser = MCBrowserViewController(serviceType: "bbplus2016", session: session)
        browser.delegate = self
        sceneVC = Util.getForegroundViewController()
        sceneVC.presentViewController(browser, animated: true, completion: nil)
    }
    
    func setupLoadingComponent() {
        loadingBkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
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
            let dic: Dictionary = ["isPaused": self.paused]
            let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(dic)
            try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
        } catch _ as NSError {
            print("sendPauseData failed")
        }
    }
    
    func sendLifeData(lifeCount: Int) {
        do {
            let dic: Dictionary = ["lifeCount": lifeCount]
            let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(dic)
            try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
        } catch _ as NSError {
            print("sendLifeData failed")
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        let dataObj = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as AnyObject
        let dataDic = dataObj as! Dictionary<String, AnyObject>
        //※point!!（非同期なのでpromiseで認知してあげる必要がある.）
        dispatch_async(dispatch_get_main_queue()) {
                print("data : \(data)")
            let lifeCount = dataDic["lifeCount"] as! Int
            self.headerViewMatch.disapperAnimation(PlayerType.PLAYER2, life: lifeCount)
        }
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case MCSessionState.Connected:
            print("Connected: \(peerID.displayName)")
            dispatch_async(dispatch_get_main_queue(), {
                self.headerViewMatch.playerLabel1.text = UIDevice.currentDevice().name
                self.headerViewMatch.playerLabel2.text = peerID.displayName
                self.hideLoadingComponent()
                self.browser.dismissViewControllerAnimated(true, completion: nil)
                self.countdownView.start()
            })
            
        case MCSessionState.Connecting:
            print("Connecting: \(peerID.displayName)")
            dispatch_async(dispatch_get_main_queue()) {
                self.showLoadingComponent()
                self.browser.view.addSubview(self.loadingBkView)
            }
            
        case MCSessionState.NotConnected:
            print("Not Connected: \(peerID.displayName)")
            dispatch_async(dispatch_get_main_queue()) {
                self.hideLoadingComponent()
                let alert: UIAlertController = UIAlertController(title: "接続失敗", message: "再度デバイスを選択して下さい", preferredStyle:  UIAlertControllerStyle.Alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                self.browser.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    }
    
    func browserViewController(browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        hideLoadingComponent()
        browser.dismissViewControllerAnimated(true, completion: nil)
        sceneVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        hideLoadingComponent()
        browser.dismissViewControllerAnimated(true, completion: nil)
        sceneVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
