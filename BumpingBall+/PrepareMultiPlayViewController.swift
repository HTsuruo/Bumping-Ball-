//
//  PrepareMultiPlayViewController.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import LTMorphingLabel

class PrepareMultiPlayViewController: UIViewController, LTMorphingLabelDelegate {
    let util = Utils()
    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var timer: NSTimer? = nil

    @IBOutlet weak var bluetoothArea: UIView!
    @IBOutlet weak var networkArea: UIView!
    @IBOutlet weak var bluetoothAiView: NVActivityIndicatorView!
    @IBOutlet weak var networkAiView: NVActivityIndicatorView!
    @IBOutlet weak var animationLabel: LTMorphingLabel!
    
    private var i = 0
    private var txtArr = ["遊び方を選択して下さい", "アイテムを上手く使いましょう"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        util.setStatusBar(self.view)
        self.view.backgroundColor = colorUtils.navy
        animationLabel.delegate = self
        let effect = LTMorphingEffect.Evaporate
        animationLabel.morphingEffect = effect
        bluetoothAiView.startAnimation()
        networkAiView.startAnimation()
        
        timer = NSTimer(timeInterval: 2.0, target: self, selector:#selector(PrepareMultiPlayViewController.changeTxt), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func changeTxt() {
        animationLabel.text = text
    }

    var text: String {
        get {
            if i >= (txtArr.count-1) {
                i = -1
            }
            i+=1
            return txtArr[i]
        }
    }
    
    @IBAction func onClickBackBtn(sender: UIButton) {
        timer?.invalidate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onClickBluetoothPlayBtn(sender: UIButton) {
        timer?.invalidate()
        app.selectedPlay = PlayType.BLUETOOTH
        self.performSegueWithIdentifier("toMultiPlay", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
