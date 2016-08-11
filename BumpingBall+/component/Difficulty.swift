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
    var score = 0
    
    //ボールの速度を上げます.
    func getAccelerationSpped() -> Double {
        return 0.0
    }
    
    //ボールの生成頻度を多くします.
    func getInterval() -> CFTimeInterval {
        return 3
    }
}
