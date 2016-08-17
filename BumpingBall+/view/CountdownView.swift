//
//  CountdownView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/17.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class CountdownView: UIView {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    
    var countdownTime = 3
    var countdownTimer = NSTimer()
    let util = Utils()
    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadXib() {
        NSBundle.mainBundle().loadNibNamed("CountdownView", owner: self, options: nil)
        contentView.frame = CGRectMake(0, 0, define.WIDTH, define.HEIGHT)
        self.addSubview(contentView)
    }
    
    func start() {
        countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CountdownView.countdown), userInfo: nil, repeats: true)
    }
    
    func countdown() { // this is the function called by the timer every second, which causes your "countdownTime" to go down by 1. When it reaches 0, it starts the game.
        countdownTime -= 1
        if countdownTime > 0 {
            label.text = String(countdownTime)
        }
        if countdownTime == 0 {
            countdownTimer.invalidate()
            label.text = "GO!!"
            app.isStart = true
            self.removeFromSuperview()
        }
    }

}
