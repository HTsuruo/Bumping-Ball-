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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setStatusBar(self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
