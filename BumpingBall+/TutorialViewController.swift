//
//  TutorialViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/10.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialViewController: UIViewController {

    var skView = SKView()
    var scene = SKScene()
    var tutorialScene: TutorialScene! = nil
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    let tutorialTxt: [String] = ["チュートリアルを始めるよ！！", "下部のエリアをタップすると\nカラーボールが発射するよ!!"]
    
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
        }
        self.view.addSubview(skView)
        self.view.sendSubview(toBack: skView)
        
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
//        tutorialScene = scene as! TutorialScene //100%なので
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
        nextBtn.isHidden = true
        label.text = tutorialTxt[tutorialScene.tutorialNumber]
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
