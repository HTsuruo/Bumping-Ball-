//
//  Enums.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/02.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

enum BallType: Int {
    case BLUE = 1
    case GREEN = 2
    case ORANGE = 3
    case RED = 4
    
    func getImageName(key: BallType) -> String {
        switch self {
        case BLUE:
            return "ball_blue"
        case GREEN:
            return "ball_green"
        case ORANGE:
            return "ball_orange"
        case RED:
            return "ball_red"
        }
    }
    
    func getSize(key: BallType) -> Int {
        switch self {
        case BLUE:
            return 20
        case GREEN:
            return 40
        case ORANGE:
            return 60
        case RED:
            return 80
        }
    }
    
}
