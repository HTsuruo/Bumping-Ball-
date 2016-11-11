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
    var tutorialTxt: [String] = []
    var fingetText: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...tutorialNumberMax {
            tutorialTxt.append(NSLocalizedString("tutorial_text_\(i)", comment: ""))
            fingetText.append(NSLocalizedString("tutorial_finger_text_\(i)", comment: ""))
        }
        
        app.selectedDiffculty = DifficultyType.tutorial
        label.numberOfLines = 0
        fingerIcon.isHidden = true
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: define.HEADER_HEIGHT))
        headerLabel.text = NSLocalizedString("tutorial", comment: "")
        headerLabel.textColor = UIColor.white
        headerLabel.backgroundColor = UIColor.hex(hexStr: "FFFFFF", alpha: 0.3)
        headerLabel.font = UIFont.systemFont(ofSize: 22.0)
        headerLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(headerLabel)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(true, forKey: udKey.is_not_first)
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
    
    @IBAction func onClickNextBtn(_ sender: UIButton) {
        print("next!!")
        if tutorialScene.tutorialNumber == tutorialNumberMax {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
