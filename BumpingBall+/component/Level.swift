//
//  Level.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/12/10.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class Level {
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var filename = "level"
    var dic: NSDictionary? = nil
    let speedVal = DeviceUtil.getOptionalSpeed()
    
    init() {
        if app.selectedPlay == .one {
            filename = "level"
        } else {
            filename = "level_multi"
        }
        print("filename: \(filename)")
        let filepath = Bundle.main.path(forResource: filename, ofType: "plist")
        dic = NSDictionary(contentsOfFile: filepath!)
    }
    
    func updateParam() {
        if app.level == 0 {
            app.level = 1
        }
        app.accelation = getAccelation()
        app.interval = getInterval()
        print("level: \(app.level)")
        print("accelation: \(app.accelation)")
        print("interval: \(app.interval)")
    }
    
    func getAccelation() -> Double {
        let level = app.level
        if let valdic: NSDictionary = dic?.object(forKey: "\(level)") as? NSDictionary {
            let acceleration = valdic.object(forKey: "acceleration") as! Double * speedVal
            print("acceleration: \(acceleration)")
            return acceleration
        }
        return 2.0 * speedVal
    }
    
    func getInterval() -> CFTimeInterval {
        let level = app.level
        if let valdic: NSDictionary = dic?.object(forKey: "\(level)") as? NSDictionary {
            let interval = valdic.object(forKey: "interval") as! Double
            print("interval: \(interval)")
            return interval
        }
        return 0.75
    }
    
}
