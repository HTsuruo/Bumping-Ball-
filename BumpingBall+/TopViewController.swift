//
//  TopViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import Spring

class TopViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GKGameCenterControllerDelegate {
    
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let skView = SKView()
    var sceneView = SceneViewController()
    @IBOutlet weak var onePlayBtn: SpringButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    fileprivate let difficulties: NSArray = ["Easy", "Normal", "Hard"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewInit()
        UIApplication.setStatusBar(self.view)
    
        if let scene = TopScene(fileNamed:"TopScene") {
            // Configure the view.
            skView.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .resizeFill
            
            skView.allowsTransparency = true
            skView.presentScene(scene)
        }
        self.view.addSubview(skView)
        self.view.sendSubview(toBack: skView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    @IBAction func onClickOnePlayBtn(_ sender: UIButton) {
        app.selectedPlay = PlayType.one
        self.performSegue(withIdentifier: "toPlay", sender: self)
    }
    
    @IBAction func onClickMultiPlayBtn(_ sender: UIButton) {
//        app.selectedPlay = PlayType.BLUETOOTH
        self.performSegue(withIdentifier: "toPrepareMulti", sender: self)
    }
    
    @IBAction func onClickRankBtn(_ sender: UIButton) {
        sendAllScore()
        let localPlayer = GKLocalPlayer()
        localPlayer.loadDefaultLeaderboardIdentifier { (leaderboardIdentifier, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
                gcViewController.gameCenterDelegate = self
                gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
                gcViewController.leaderboardIdentifier = "normal"
                self.present(gcViewController, animated: true, completion: nil)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func sendAllScore() {
        let ud = UserDefaults.standard
        GameCenterUtil.sendScore(ud.integer(forKey: "highscore-easy"), leaderBoardId: "easy")
        GameCenterUtil.sendScore(ud.integer(forKey: "highscore-normal"), leaderBoardId: "normal")
        GameCenterUtil.sendScore(ud.integer(forKey: "highscore-hard"), leaderBoardId: "hard")
    }
    
    /** picker view setting **/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficulties.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 40))
        label.text = String(describing: difficulties[row])
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Candara", size: 24)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
//        switch row {
//            case 0:
//                label.textColor = colorUtil.blue
//            case 1:
//                label.textColor = colorUtil.green
//            case 2:
//                label.textColor = colorUtil.red
//            default:
//                label.textColor = colorUtil.clear
//        }
        
        return label
    }
    
    // 選択された時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected: \(row), \(difficulties[row])")
        app.selectedDiffculty = DifficultyType(rawValue: row)!
        setSelectedBkColor(row)
    }
    
    func pickerViewInit() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.clear
        pickerView.layer.masksToBounds = true
        pickerView.layer.cornerRadius = 10.0
        pickerView.selectRow(app.selectedDiffculty.rawValue, inComponent: 0, animated: false)
        setSelectedBkColor(app.selectedDiffculty.rawValue)
    }
    
    func setSelectedBkColor (_ row: Int) {
        switch row {
        case 0:
            pickerView.backgroundColor = colorUtil.blue
        case 1:
            pickerView.backgroundColor = colorUtil.green
        case 2:
            pickerView.backgroundColor = colorUtil.red
        default:
            pickerView.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func onClickRightBtn(_ sender: SpringButton) {
        if let session = app.bluetoothSession {
            session.disconnect()
        }
    }
    
}
