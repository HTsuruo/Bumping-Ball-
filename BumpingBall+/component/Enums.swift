//
//  Enums.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/02.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

enum BallType: Int {
    case BLUE = 0
    case GREEN = 1
    case ORANGE = 2
    case RED = 3
    case GOLD = 100
    
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
        case GOLD:
            return "ball_gold"
        }
    }
    
    func getSize(key: BallType) -> CGFloat {
        switch self {
        case BLUE:
            return 20.0
        case GREEN:
            return 40.0
        case ORANGE:
            return 60.0
        case RED:
            return 80.0
        case GOLD:
            return 100.0
        }
    }
}

enum DifficultyType: Int {
    case EASY = 0
    case NORMAL = 1
    case HARD = 2
    case IMPOSSIBLE = 3
    
    func getString() -> String {
        switch self {
        case .EASY:
            return "easy"
        case .NORMAL:
            return "normal"
        case .HARD:
            return "hard"
        case .IMPOSSIBLE:
            return "impossible"
        }
    }
    
    func isEasy() -> Bool {
        switch self {
        case .EASY:
            return true
        default:
            false
        }
        return false
    }
    
}

enum PlayType: Int {
    case ONE = 0
    case BLUETOOTH = 1
    case NETWORK = 2
}

enum PlayerType: Int {
    case PLAYER1 = 1
    case PLAYER2 = 2
}
