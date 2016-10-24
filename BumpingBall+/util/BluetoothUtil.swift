//
//  BluetoothUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/21.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import NVActivityIndicatorView
import SpriteKit

class BluetoothUtil: NSObject, MCSessionDelegate, MCAdvertiserAssistantDelegate, MCBrowserViewControllerDelegate {
    
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: UIColor.white)
    var loadingBkView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT))
    var vc: UIViewController! = nil
    var scene: BluetoothPlay! = nil
    
    init(scene: BluetoothPlay) {
        self.scene = scene
        self.vc = Util.getForegroundViewController()
    }
    
    func setupSession() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        
        advertiser = MCAdvertiserAssistant(serviceType: "bbplus2016", discoveryInfo: nil, session: session)
        advertiser?.delegate = self
        advertiser?.start()
        
        browser = MCBrowserViewController(serviceType: "bbplus2016", session: session)
        browser.delegate = self
        self.vc.present(browser, animated: true, completion: nil)
    }
    
    func setupLoadingComponent() {
        loadingBkView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        loadingView.center = CGFloat.CENTER
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
    
    // sendData data.
    func sendData(dic: [String: AnyObject]) {
        do {
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: dic)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch _ as NSError {
            print("sendData failed")
        }
    }
    
    
    // receive data.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dataObj = NSKeyedUnarchiver.unarchiveObject(with: data)! as AnyObject
        let dataDic = dataObj as! Dictionary<String, AnyObject>
        //※point!!（非同期なのでpromiseで認知してあげる必要がある.）
        DispatchQueue.main.async {
            self.scene.receiveData(data: dataDic)
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async(execute: {
                self.app.bluetoothSession = session
                self.scene.headerViewMatch.playerLabel1.text = UIDevice.current.name
                self.scene.headerViewMatch.playerLabel2.text = peerID.displayName
                self.hideLoadingComponent()
                self.browser.dismiss(animated: true, completion: nil)
                
                let alert: UIAlertController = UIAlertController(title: " 準備完了", message: "接続が完了しました\nOKを押すとスタートします", preferredStyle:  UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) -> Void in
                    self.scene.sessionConnected()
                })
                alert.addAction(defaultAction)
                self.vc.present(alert, animated: true, completion: nil)
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
                let alert = AlertUtil()
                if self.app.bluetoothSession != nil {
                    alert.eroorMsg(title: "接続エラー", msg: "相手との接続が切れました")
                } else {
                    alert.eroorMsg(title: "接続失敗", msg: "左上のキャンセルボタンを押した後、再度デバイスを選択して下さい")
                }
                self.app.bluetoothSession = nil
            }
        }
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
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
        self.vc.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        hideLoadingComponent()
        browser.dismiss(animated: true, completion: nil)
        self.vc.dismiss(animated: true, completion: nil)
    }

}
