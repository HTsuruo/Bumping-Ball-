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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class Difficulty {
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //ボールの速度を上げます.
    func getAccelerationSpeed() -> Double {
        let score = app.score
        
        if score < 1000 {
            return 0.0
        }
        if isInRange(score!, from: 1000, to: 1000 * 10) {
            return getSpeed(1000 * 10, score: score!, alpha: 0.0)
        }
        if isInRange(score!, from: 10000, to: 10000 * 10) {
            return getSpeed(10000 * 10, score: score!, alpha: 1.0)
        }
        if isInRange(score!, from: 100000, to: 100000 * 10) {
            return getSpeed(100000 * 10, score: score!, alpha: 2.0)
        }
        if isInRange(score!, from: 1000000, to: 1000000 * 10) {
            return getSpeed(1000000 * 10, score: score!, alpha: 3.0)
        }
        return 5.0
    }
    
    //ボールの生成頻度を多くします.
    func getInterval() -> CFTimeInterval {
        let score = app.score
        
        if score < 1000 {
            return 5.0
        }
        if isInRange(score!, from: 1000, to: 5000) {
            return getInterval(1000 * 10, score: score!, alpha: 0.25)
        }
        if isInRange(score!, from: 5000, to: 10000) {
            return getInterval(1000 * 10, score: score!, alpha: 0.5)
        }
        if isInRange(score!, from: 10000, to: 15000) {
            return getInterval(10000 * 10, score: score!, alpha: 1.0)
        }
        if isInRange(score!, from: 15000, to: 20000) {
            return getInterval(10000 * 10, score: score!, alpha: 1.5)
        }
        if isInRange(score!, from: 20000, to: 30000) {
            return getInterval(10000 * 10, score: score!, alpha: 1.75)
        }
        if isInRange(score!, from: 30000, to: 40000) {
            return getInterval(10000 * 10, score: score!, alpha: 2.0)
        }
        if isInRange(score!, from: 40000, to: 50000) {
            return getInterval(10000 * 10, score: score!, alpha: 2.25)
        }
        if isInRange(score!, from: 50000, to: 75000) {
            return getInterval(10000 * 10, score: score!, alpha: 2.5)
        }
        if isInRange(score!, from: 75000, to: 100000) {
            return getInterval(10000 * 10, score: score!, alpha: 3.0)
        }
        if isInRange(score!, from: 100000, to: 150000) {
            return getInterval(100000 * 10, score: score!, alpha: 3.5)
        }
        if isInRange(score!, from: 150000, to: 1000000) {
            return getInterval(100000 * 10, score: score!, alpha: 3.75)
        }
        return 0.5
    }
    
    func isInRange(_ score: Int, from: Int, to: Int) -> Bool {
        if from <= score && score < to {
            return true
        }
        return false
    }
    
    func getSpeed(_ division: Double, score: Int, alpha: Double) -> Double {
        return ((Double(score) / division) + alpha)/2
    }
    
    func getInterval(_ division: Double, score: Int, alpha: Double) -> Double {
        return (5.0-((Double(score) / division)+alpha))
    }
    
}
