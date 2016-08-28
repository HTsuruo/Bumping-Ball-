//
//  PrepareMultiPlayViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class PrepareMultiPlayViewController: UIViewController {
    let util = Utils()
    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        util.setStatusBar(self.view)
        self.view.backgroundColor = colorUtils.navy
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBackBtn(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onClickBluetoothPlayBtn(sender: UIButton) {
        app.selectedPlay = PlayType.BLUETOOTH
        self.performSegueWithIdentifier("toMultiPlay", sender: self)
    }
}
