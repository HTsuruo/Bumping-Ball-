//
//  Ball.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/02.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

struct Ball {
    var ballId = 0
    var ball = SKSpriteNode()
    var ballScale = CGFloat(0.3)
    var isTouch = true
    var isFire = false
}

struct ballImage {
    static let BLUE = "ball_blue"
    static let GREEN = "ball_green"
    static let ORANGE = "ball_orange"
    static let RED = "ball_red"
}
