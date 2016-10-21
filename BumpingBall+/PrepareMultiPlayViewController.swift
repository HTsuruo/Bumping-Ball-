//
//  PrepareMultiPlayViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PrepareMultiPlayViewController: UIViewController {
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer: Timer? = nil

    @IBOutlet weak var bluetoothArea: UIView!
    @IBOutlet weak var networkArea: UIView!
    @IBOutlet weak var animationLabel: UILabel!
    
    fileprivate var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorUtils.navy
        UIApplication.setStatusBar(self.view)
//        bluetoothAiView.startAnimating()
//        networkAiView.startAnimating()
//        bluetoothAiView.alpha = 0.0
    }
    
    @IBAction func onClickBackBtn(_ sender: UIButton) {
        timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickBluetoothPlayBtn(_ sender: UIButton) {
        timer?.invalidate()
        app.selectedPlay = PlayType.bluetooth
        self.performSegue(withIdentifier: "toMultiPlay", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
