//
//  TopViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class TopViewController: UIViewController {
    
    let utils = Utils()
    let skView = SKView()
    @IBOutlet weak var onePlayBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setStatusBar(self.view)
        
        if let scene = FinishScene(fileNamed:"FinishScene") {
            // Configure the view.
            skView.frame = CGRectMake(0, define.HEIGHT-50, define.WIDTH, 50)
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
        }
        self.view.addSubview(skView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func onePlayBtnClicked(sender: UIButton) {
        let onePlayVC = self.storyboard?.instantiateViewControllerWithIdentifier("onePlayVC") as! GameViewController
        onePlayVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(onePlayVC, animated: true, completion: nil)
    }
}
