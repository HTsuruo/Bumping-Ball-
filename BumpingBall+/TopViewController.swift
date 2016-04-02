//
//  TopViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    let utils = Utils()
    @IBOutlet weak var onePlayBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setStatusBar(self.view)
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
