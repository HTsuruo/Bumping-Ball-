//
//  TutorialViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/10.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit
import Spring

class TutorialViewController: UIViewController {

    var skView = SKView()
    var tutorialScene: TutorialScene! = nil
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextBtn: SpringButton!
    @IBOutlet weak var fingerLabel: UILabel!
    @IBOutlet weak var fingerIcon: SpringImageView!
    private let tutorialNumberMax = 5
    let tutorialTxt: [String] = ["チュートリアルを始めるよ！！", "下部のエリアをタップすると\nカラーボールが発射するよ!!", "長押しでカラーボールの色が変化するよ!!", "落下してくるカラーボールと\n同じ色をぶつけよう!!\n連続でぶつけるとコンボが発生するぞ!!", "コンボでゲージが溜まったら\n上にスワイプして\nゴールドボールを発射しよう!!", "落下してくるカラーボールが\n下のエリアに入ったら\nゲームオーバーだ..\nハイスコアを目指そう!!\n対戦モードも楽しんでね!!"]
    let fingetText: [String] = ["", " タップ!!", "長押し", "", "はじく!!", "ココ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = TutorialScene(fileNamed:"PlayScene") {
            // Configure the view.
            skView.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .resizeFill
            
            skView.allowsTransparency = true
            skView.presentScene(scene)
            tutorialScene = scene 
        }
        self.view.addSubview(skView)
        self.view.sendSubview(toBack: skView)
        
        label.numberOfLines = 0
        fingerIcon.isHidden = true
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: define.HEADER_HEIGHT))
        headerLabel.text = NSLocalizedString("tutorial", comment: "")
        headerLabel.textColor = UIColor.white
        headerLabel.backgroundColor = UIColor.hex(hexStr: "FFFFFF", alpha: 0.3)
        headerLabel.font = UIFont.systemFont(ofSize: 22.0)
        headerLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(headerLabel)
        
        setupContent()
        
    }
    
    func setupContent() {
        let num = tutorialScene.tutorialNumber
        label.text = tutorialTxt[num]
        fingerLabel.text = fingetText[num]
        if num == 1 || num == 2 || num == 3 {
            fingerIcon.isHidden = false
        }
        
        if num == tutorialNumberMax {
            nextBtn.setImage(UIImage(named: "startBtn"), for: UIControlState.normal)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
    }
    
    @IBAction func onClickNextBtn(_ sender: UIButton) {
        print("next!!")
        if tutorialScene.tutorialNumber == tutorialNumberMax {
            self.performSegue(withIdentifier: "toMain", sender: self)
            return
        }
//        nextBtn.isHidden = true
        tutorialScene.tutorialNumber += 1
        setupContent()
    }
    
    func isOk() {
        nextBtn.animate()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
