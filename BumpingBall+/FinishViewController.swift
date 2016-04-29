//
//  FinishViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/19.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    
    let finishView = FinishView(frame: CGRectMake(0, 0, define.WIDTH, define.HEIGHT))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(finishView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
