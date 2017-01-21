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

class TopViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let skView = SKView()
    var sceneView = SceneViewController()
    var waitingView = WaitingView()
    @IBOutlet weak var onePlayBtn: SpringButton!
//    @IBOutlet weak var pickerView: UIPickerView!
    var levelSelectView: LevelSelectView! = nil
    let bkview = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT))
    let btnSound = Sound.prepareToPlay(Sound.button)
    let btnErorrSound = Sound.prepareToPlay(Sound.buttonError)
    
    fileprivate let difficulties: NSArray = ["Easy", "Normal", "Hard"]
    
    override func viewWillAppear(_ animated: Bool) {
        bkview.isHidden = true
        if let view = levelSelectView {
            view.removeFromSuperview()
        }
//        bgmが止まっていたら流す
        if !Bgm.isPlaying() {
            Bgm.playBgm(filename: Bgm.topMusic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.versionCheck()
        popupBkInit()
        
//        pickerViewInit()
    
        if let scene = TopScene(fileNamed:"TopScene") {
            // Configure the view.
            skView.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .resizeFill
            
            skView.allowsTransparency = true
            skView.presentScene(scene)
        }
        self.view.addSubview(skView)
        self.view.sendSubview(toBack: skView)
        Bgm.playBgm(filename: Bgm.topMusic)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    @IBAction func onClickOnePlayBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSound)
        app.selectedPlay = PlayType.one 
        levelSelectView = LevelSelectView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH - (CGFloat.WIDTH * 0.3), height: CGFloat.HEIGHT - (CGFloat.HEIGHT * 0.58)))
        levelSelectView.center = CGFloat.CENTER
        self.view.addSubview(levelSelectView)
        bkview.isHidden = false
        levelSelectView.startAnimation()
    }
    
    @IBAction func onClickSecondBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSound)
        app.selectedPlay = PlayType.bluetooth
        transitionToPlay()
    }
    
    @IBAction func onClickThirdBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnErorrSound)
        let alertUtil = AlertUtil()
        alertUtil.eroorMsg(title: NSLocalizedString("info", comment: ""), msg: NSLocalizedString("gamecenter_not_play", comment: ""))
    }
    
    func transitionToPlay() {
        self.performSegue(withIdentifier: "toPlay", sender: self)
    }
    
    /** ランキング **/
    @IBAction func onClickRankBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSound)
        showWaitingView()
        sendAllScore()
        let localPlayer = GKLocalPlayer()
        localPlayer.loadDefaultLeaderboardIdentifier { (leaderboardIdentifier, error) in
            if error != nil {
                print(error!.localizedDescription)
                AlertUtil().eroorMsgWithCloseBtn(title: NSLocalizedString("error", comment: ""), msg: NSLocalizedString("error_gamecenter_msg", comment: ""))
            } else {
                let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
                gcViewController.gameCenterDelegate = self
                gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
                gcViewController.leaderboardIdentifier = "normal"
                self.present(gcViewController, animated: true, completion: nil)
            }
            self.waitingView.hide()
        }
    }
    
    /** ヘルプ **/
    @IBAction func onClickHelpBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSound)
        self.performSegue(withIdentifier: "toHelp", sender: self)
    }
    
    /** 設定 **/
    @IBAction func onClickSettingBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSound)
        self.performSegue(withIdentifier: "toSetting", sender: self)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func sendAllScore() {
        let ud = UserDefaults.standard
        GameCenterUtil.sendScore(ud.integer(forKey: "highscore-easy"), leaderBoardId: DifficultyType.easy.getString())
        GameCenterUtil.sendScore(ud.integer(forKey: "highscore-normal"), leaderBoardId: DifficultyType.normal.getString())
        GameCenterUtil.sendScore(ud.integer(forKey: "highscore-hard"), leaderBoardId: DifficultyType.hard.getString())
    }
    
    func popupBkInit() {
        self.view.addSubview(bkview)
        bkview.isHidden = true
        bkview.backgroundColor = UIColor.black
        bkview.alpha = 0.85
        bkview.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        bkview.addGestureRecognizer(gesture)
    }
    
    func onTap(_ sender: UITapGestureRecognizer) {
        levelSelectView.removeFromSuperview()
        bkview.isHidden = true
    }
    
    /** picker view setting **/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func showWaitingView() {
        self.view.addSubview(waitingView)
        waitingView.txt.text = "Connecting.."
        waitingView.show()
    }
    
    /*
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
//                label.textColor = ColorUtil.blue
//            case 1:
//                label.textColor = ColorUtil.green
//            case 2:
//                label.textColor = ColorUtil.red
//            default:
//                label.textColor = ColorUtil.clear
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
            pickerView.backgroundColor = ColorUtil.blue
        case 1:
            pickerView.backgroundColor = ColorUtil.green
        case 2:
            pickerView.backgroundColor = ColorUtil.red
        default:
            pickerView.backgroundColor = UIColor.clear
        }
    }
 */
    
}
