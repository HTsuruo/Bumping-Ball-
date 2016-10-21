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

class SceneViewController: UIViewController {

    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var skView = SKView()
    let countdownView = CountdownView()
    let finishView = FinishView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT))
    var scene = SKScene()
    @IBOutlet var pauseMenu: UIView!
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var quitBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    var isMultiPlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        skView.showsFPS = true
        skView.showsNodeCount = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

        //pauseボタン
        let pauseBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        let pauseImage = UIImage(named:"pauseBtn")
        pauseBtn.setImage(pauseImage, for: UIControlState())
        pauseBtn.addTarget(self, action: #selector(SceneViewController.onClickPauseBtn(_:)), for: .touchUpInside)
        self.view.addSubview(pauseBtn)
        loadNib()
    }
    
    func loadNib() {
        pauseMenu = UINib(nibName: "PauseMenu", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        pauseMenu.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

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

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    internal func onClickPauseBtn(_ sender: UIButton) {
        Sound.prepareToPlay("pause")
        Sound.play()
        skView.isPaused = true
        countdownView.stop()
        self.view.addSubview(pauseMenu)
    }
    
    @IBAction func onClickResumeBtn(_ sender: UIButton) {
        skView.isPaused = false
        pauseMenu.removeFromSuperview()
    }

    @IBAction func onClickQuitBtn(_ sender: UIButton) {
        let onePlayVC = Util.getForegroundViewController()
        onePlayVC.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restartBtn(_ sender: UIButton) {
        self.loadView()
        self.viewDidLoad()
    }
    
}
