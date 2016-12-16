//
//  Enums.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/02.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import Foundation

enum BallType: Int {
    case blue = 0
    case green = 1
    case orange = 2
    case red = 3
    case gold = 100
    
    //itemBall
    case reverse = 200
    case speedup = 201
    case oneup = 202
    
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
        default:
            return ""
        }
    }
    
    func isSpecialItemBall() -> Bool {
        return (self == .reverse || self == .speedup || self == .oneup)
    }
}

enum DifficultyType: Int {
    case tutorial = 0
    case easy = 1
    case normal = 2
    case hard = 3
    case impossible = 4
    
    func getString() -> String {
        switch self {
        case .tutorial:
            return "tutorial"
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
    
    func canCreateHasNumber() -> Bool {
        switch self {
        case .normal:
            return true
        case .hard:
            return true
        case .impossible:
            return true
        default:
            return false
        }
    }
    
    func isEasy() -> Bool {
        switch self {
        case .easy:
            return true
        default:
            return false
        }
    }
    
}

enum PlayType: Int {
    case one = 0
    case bluetooth = 1
    case network = 2
    
    func isOnePlay() -> Bool {
        switch self {
        case .one:
            return true
        default:
            return false
        }
    }
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

//setting
enum SettingType: Int {
    case music = 0
    case sound = 1
    case review = 10
    case licence = 11
    case version = 12
}
