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

    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var skView = SKView()
    var tutorialScene: TutorialScene! = nil
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextBtn: SpringButton!
    @IBOutlet weak var fingerLabel: UILabel!
    @IBOutlet weak var fingerIcon: SpringImageView!
    private let tutorialNumberMax = 5
    @IBOutlet weak var swipeFingerArrow: UIImageView!
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    var tutorialTxt: [String] = [
        NSLocalizedString("tutorial_text_0", comment: "tutorial"),
        NSLocalizedString("tutorial_text_1", comment: "tap"),
        NSLocalizedString("tutorial_text_2", comment: "keep"),
        NSLocalizedString("tutorial_text_3", comment: "collision"),
        NSLocalizedString("tutorial_text_4", comment: "swipe"),
        NSLocalizedString("tutorial_text_5", comment: "last")
    ]
    var fingetText: [String] = [
        NSLocalizedString("tutorial_finger_text_0", comment: ""),
        NSLocalizedString("tutorial_finger_text_1", comment: ""),
        NSLocalizedString("tutorial_finger_text_2", comment: ""),
        NSLocalizedString("tutorial_finger_text_3", comment: ""),
        NSLocalizedString("tutorial_finger_text_4", comment: ""),
        NSLocalizedString("tutorial_finger_text_5", comment: ""),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        app.selectedDiffculty = DifficultyType.tutorial
        label.numberOfLines = 0
        fingerIcon.isHidden = true
        
        if !UserDefaults.standard.bool(forKey: udKey.is_not_first) {
            closeBtn.isEnabled = false
            closeBtn.tintColor = UIColor.clear
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //sceneで最前面のviewcontrollerを取得する処理があるため、viewdidapperでインスタンス化します.
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
        setupContent()
        nextBtn.isHidden = false
        fingerIcon.isHidden = true
    }
    
    func setupContent() {
        nextBtn.isHidden = true
        swipeFingerArrow.isHidden = true
        
        let num = tutorialScene.tutorialNumber
        label.text = tutorialTxt[num]
        fingerLabel.text = fingetText[num]
        
        switch num {
        case 1:
            fingerIcon.isHidden = false
            break
        case 2:
            fingerIcon.isHidden = false
            break
        case 3:
            fingerIcon.isHidden = true
            break
        case 4:
            tutorialScene.forceChargeFull()
            swipeFingerArrow.isHidden = false
            fingerIcon.isHidden = false
            break
        case 5:
            tutorialScene.chargeReset()
            nextBtn.isHidden = false
            fingerIcon.isHidden = false
            break
        default:
            break
        }
        fingerIcon.animate()
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        skView.scene?.removeFromParent()
        skView.presentScene(nil)
    }
    
    @IBAction func onClickNextBtn(_ sender: UIButton) {
        print("next!!")
        if tutorialScene.tutorialNumber == tutorialNumberMax {
            if UserDefaults.standard.bool(forKey: udKey.is_not_first) {
                self.dismiss(animated: true, completion: nil)
                return
            }
            UserDefaults.standard.set(true, forKey: udKey.is_not_first)
            self.performSegue(withIdentifier: "toMain", sender: self)
            return
        }
        tutorialScene.tutorialNumber += 1
        setupContent()
    }
    
    func isOk() {
        nextBtn.isHidden = false
        nextBtn.animate()
    }
    
    @IBAction func onClickCloseBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
