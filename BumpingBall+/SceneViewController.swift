//
//  GameViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright (c) 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import MultipeerConnectivity

class SceneViewController: UIViewController {

    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var skView = SKView()
    let finishView = FinishView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT))
    var scene = SKScene()
    @IBOutlet var pauseMenu: UIView!
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var quitBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    var isMultiPlay = true
    var alertUtil: AlertUtil! = nil
    let pauseSound = Sound.prepareToPlay(Sound.pause)
    let btnSound = Sound.prepareToPlay(Sound.button)
    let btnErrorSound = Sound.prepareToPlay(Sound.buttonError)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertUtil = AlertUtil()
        app.theme = ThemeUtil().getTheme()
        
        let playType = app.selectedPlay
        switch playType {
        case .one:
            scene = OnePlayScene()
            isMultiPlay = false
            break
        case .bluetooth:
            scene = BluetoothPlay()
            break
        case .network:
            break
        }
        skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.isMultipleTouchEnabled = false
//        scene.scaleMode = .resizeFill
        scene.scaleMode = .aspectFill
        scene.size = skView.frame.size
        skView.presentScene(scene)

        //pauseボタン
        let pauseBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        let pauseImage = UIImage(named:"pauseBtn")
        pauseBtn.setImage(pauseImage, for: UIControlState())
        pauseBtn.addTarget(self, action: #selector(SceneViewController.onClickPauseBtn(_:)), for: .touchUpInside)
        self.view.addSubview(pauseBtn)
        loadNib()
        
        if app.selectedPlay != .one {
            app.level = 1
            return
        }
        
        switch app.selectedDiffculty {
        case .easy:
            app.level = 1
            break
        case .normal:
            app.level = 1
            break
        case .hard:
            app.level = 10
            break
        case .impossible:
            app.level = 15
            break
        default:
            app.level = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
    }
    
    func loadNib() {
        pauseMenu = UINib(nibName: "PauseMenu", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        pauseMenu.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
        Bgm.stop()
    }
    
    //sceneのupdateが止まらない場合があるのでpauseして対処します.
    override func viewDidDisappear(_ animated: Bool) {
        let top = UIApplication.shared.topViewController
//        blutooth接続用のMCBrowserViewControllerの場合はsceneを止めません.
        if top is MCBrowserViewController {
            return
        }
        skView.scene?.removeFromParent()
        skView.presentScene(nil)
    }
    
//    動作しないので一旦退避
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return UIStatusBarAnimation.fade
//    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    internal func onClickPauseBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: pauseSound)
        skView.isPaused = true
        self.view.addSubview(pauseMenu)
        sendPauseData(type: PauseType.pause)
        Bgm.stop()
        let basescene = scene as! BaseScene
        if !basescene.isStart {
            basescene.countdownView.stop()
        }
    }
    
    @IBAction func onClickResumeBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSound)
        skView.isPaused = false
        pauseMenu.removeFromSuperview()
        sendPauseData(type: PauseType.resume)
        Bgm.play()
        let basescene = scene as! BaseScene
        if !basescene.isStart {
            self.loadView()
            self.viewDidLoad()
        }
    }

    @IBAction func onClickQuitBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSound)
        let onePlayVC = Util.getForegroundViewController()
        onePlayVC.dismiss(animated: true, completion: nil)
        sendPauseData(type: PauseType.quit)
    }
    
//    one play only.
    @IBAction func restartBtn(_ sender: UIButton) {
        if isMultiPlay {
            btnErrorSound.play()
            alertUtil.eroorMsg(title: "注意", msg: "この機能はマルチプレイモードではご利用できません")
            return
        }
        Sound.play(audioPlayer: btnSound)
        self.loadView()
        self.viewDidLoad()
    }
    
    func sendPauseData(type: PauseType) {
        if !isMultiPlay {
            return
        }
        let playType = app.selectedPlay
        switch playType {
        case .one:
            break
        case .bluetooth:
            let bluetoothScene = scene as! BluetoothPlay
            bluetoothScene.sendPauseData(type: type)
            break
        case .network:
            break
        }
    }
    
}
