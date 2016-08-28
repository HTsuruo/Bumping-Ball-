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

    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let util = Utils()
    var skView = SKView()
    let countdownView = CountdownView()
    let finishView = FinishView(frame: CGRectMake(0, 0, define.WIDTH, define.HEIGHT))
    var scene = SKScene()
    @IBOutlet var pauseMenu: UIView!
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var quitBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playType = app.selectedPlay
        switch playType {
        case .ONE:
            scene = OnePlayScene()
            break
        case .BLUETOOTH:
            scene = BluetoothPlay()
            break
        case .NETWORK:
            break
        }
        skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)

        //pauseボタン
        let pauseBtn = UIButton(frame: CGRectMake(10, 10, 40, 40))
        let pauseImage = UIImage(named:"pauseBtn")
        pauseBtn.setImage(pauseImage, forState: .Normal)
        pauseBtn.addTarget(self, action: #selector(SceneViewController.onClickPauseBtn(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(pauseBtn)
        loadNib()
    }
    
    func loadNib() {
        pauseMenu = UINib(nibName: "PauseMenu", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! UIView
        pauseMenu.frame = CGRectMake(0, 0, define.WIDTH, define.HEIGHT)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    internal func onClickPauseBtn(sender: UIButton) {
        Sound.prepareToPlay("pause")
        Sound.play()
        skView.paused = true
        countdownView.stop()
        self.view.addSubview(pauseMenu)
    }
    
    @IBAction func onClickResumeBtn(sender: UIButton) {
        skView.paused = false
        pauseMenu.removeFromSuperview()
    }

    @IBAction func onClickQuitBtn(sender: UIButton) {
        let onePlayVC = util.getForegroundViewController()
        onePlayVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func restartBtn(sender: UIButton) {
        self.loadView()
        self.viewDidLoad()
    }
    
}
