//
//  Enums.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/02.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

enum BallType: Int {
    case blue = 0
    case green = 1
    case orange = 2
    case red = 3
    case gold = 100
    
    func getImageName(_ key: BallType) -> String {
        switch self {
        case .blue:
            return "ball_blue"
        case .green:
            return "ball_green"
        case .orange:
            return "ball_orange"
        case .red:
            return "ball_red"
        case .gold:
            return "ball_gold"
        }
    }
    
    func getSize(_ key: BallType) -> CGFloat {
        switch self {
        case .blue:
            return 20.0
        case .green:
            return 40.0
        case .orange:
            return 60.0
        case .red:
            return 80.0
        case .gold:
            return 100.0
        }
    }
}

enum DifficultyType: Int {
    case easy = 0
    case normal = 1
    case hard = 2
    case impossible = 3
    
    func getString() -> String {
        switch self {
        case .easy:
            return "easy"
        case .normal:
            return "normal"
        case .hard:
            return "hard"
        case .impossible:
            return "impossible"
        }
    }
    
    func isEasy() -> Bool {
        switch self {
        case .easy:
            return true
        default:
            false
        }
        return false
    }
    
}

enum PlayType: Int {
    case one = 0
    case bluetooth = 1
    case network = 2
}

enum PlayerType: Int {
    case player1 = 1
    case player2 = 2
}

enum PauseType: Int {
    case pause = 0
    case resume = 1
    case restart = 2
    case quit = 3
}
