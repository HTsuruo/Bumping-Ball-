//
//  Difficulty.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/05/02.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Difficulty {
    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //ボールの速度を上げます.
    func getAccelerationSpeed() -> Double {
        let score = app.score
        
//        print("score : \(score)")
        
        if score < 500 {
            return 0.0
        } else if score < 1000 {
            return 0.1
        } else if score < 3000 {
            return 0.3
        } else if score < 5000 {
            return 0.5
        } else if score < 10000 {
            return 0.6
        } else if score < 12500 {
            return 0.7
        } else if score < 15000 {
            return 0.8
        } else if score < 17500 {
            return 0.9
        } else if score < 20000 {
            return 1.0
        } else if score < 25000 {
            return 1.2
        } else if score < 30000 {
            return 2.0
        }
        return 3.0
    }
    
    //ボールの生成頻度を多くします.
    func getInterval() -> CFTimeInterval {
        let score = app.score
        
        if score < 500 {
            return 5.0
        } else if score < 1000 {
            return 4.0
        } else if score < 2500 {
            return 3.5
        } else if score < 5000 {
            return 3.0
        } else if score < 7500 {
            return 2.5
        } else if score < 10000 {
            return 2.0
        } else if score < 12500 {
            return 1.8
        } else if score < 15000 {
            return 1.6
        } else if score < 17500 {
            return 1.4
        } else if score < 20000 {
            return 1.2
        } else if score < 30000 {
            return 1.0
        }
        return 0.8
      
    }
    
    
}
