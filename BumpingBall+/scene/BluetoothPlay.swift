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

class BluetoothPlay: BaseScene, MCSessionDelegate, MCAdvertiserAssistantDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        setupSession()
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
    
    func setupSession() {
        peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        session = MCSession(peer: peerID)
        session.delegate = self
        
        advertiser = MCAdvertiserAssistant(serviceType: "bbplus2016", discoveryInfo: nil, session: session)
        advertiser?.delegate = self
        advertiser?.start()
        
        browser = MCBrowserViewController(serviceType: "bbplus2016", session: session)
        browser.delegate = self
        let vc = Util.getForegroundViewController()
        vc.presentViewController(browser, animated: true, completion: nil)
    }
    
    func sendData() {
        if session.connectedPeers.count > 0 {
//            do {
//                let data = tf.text?.dataUsingEncoding(NSUTF8StringEncoding)
//                try session.sendData(data!, toPeers: session.connectedPeers, withMode: .Reliable)
//            } catch let error as NSError {
//                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .Alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            }
        }
    }
    
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case MCSessionState.Connected:
            print("Connected: \(peerID.displayName)")
            browser.dismissViewControllerAnimated(true, completion: nil)
            
        case MCSessionState.Connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.NotConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        //※point!!（非同期なのでpromiseで認知してあげる必要がある.）
        dispatch_async(dispatch_get_main_queue()) {
            print("data : \(data)")
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
        browser.dismissViewControllerAnimated(true, completion: nil)
        countdownView.start()
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        browser.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
