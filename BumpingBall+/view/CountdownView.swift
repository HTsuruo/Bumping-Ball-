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
    @IBOutlet weak var imageView: UIImageView!
    
    var countdownTime = 3
    var countdownTimer = NSTimer()
    let util = Utils()
    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        app.isStart = false
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
    
    func stop() {
        countdownTimer.invalidate()
    }
    
    func countdown() { // this is the function called by the timer every second, which causes your "countdownTime" to go down by 1. When it reaches 0, it starts the game.
        countdownTime -= 1
        
        switch countdownTime {
        case 2:
            imageView.image = UIImage(named: "two")
            break
        case 1:
            imageView.image = UIImage(named: "one")
            break
        case 0:
            imageView.image = UIImage(named: "go")
            app.isStart = true
            let w = imageView.frame.width
            let h = imageView.frame.height
            let scale: CGFloat = 2.0
            UIView.animateWithDuration(1, animations: {
                self.imageView.frame = CGRectMake(0, 0, w * scale, h * scale)
                self.imageView.center = define.CENTER
                self.imageView.alpha = 0.0
                self.contentView.alpha = 0.0
                }, completion: { finished in
                    self.countdownTimer.invalidate()
                    self.removeFromSuperview()
            })
            break
        default:
            break
        }
    }

}
