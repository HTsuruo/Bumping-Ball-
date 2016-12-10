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
    let filepath = Bundle.main.path(forResource: "level", ofType: "plist")
    var dic: NSDictionary? = nil
    
    init() {
        dic = NSDictionary(contentsOfFile: filepath!)
    }
    
    func updateParam() {
        app.accelation = getAccelation()
        app.interval = getInterval()
        print("level: \(app.level)")
        print("accelation: \(app.accelation)")
        print("interval: \(app.interval)")
    }
    
    func getAccelation() -> Double {
        let level = app.level
        if let valdic: NSDictionary = dic?.object(forKey: "\(level)") as? NSDictionary {
            let acceleration = valdic.object(forKey: "acceleration") as! Double
            print("acceleration: \(acceleration)")
            return acceleration
        }
        return 0.0
    }
    
    func getInterval() -> CFTimeInterval {
        let level = app.level
        if let valdic: NSDictionary = dic?.object(forKey: "\(level)") as? NSDictionary {
            let interval = valdic.object(forKey: "interval") as! Double
            print("interval: \(interval)")
            return interval
        }
        return 3.0
    }
    
}