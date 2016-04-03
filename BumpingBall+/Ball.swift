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
    var ball = SKSpriteNode(imageNamed: ballImage.BLUE)
    var ballScale = define.BALL_INIT_SCALE
    var isFire = false
    var ballSpeed = define.BALL_INIT_SPEED
}

struct ballImage {
    static let BLUE = "ball_blue"
    static let GREEN = "ball_green"
    static let ORANGE = "ball_orange"
    static let RED = "ball_red"
}

class BallUtils: NSObject {
    func setBlue() -> SKAction {
        let blue = SKTexture.init(imageNamed: ballImage.BLUE)
        return SKAction.setTexture(blue, resize: true)
    }
    func setGreen() -> SKAction {
        let green = SKTexture.init(imageNamed: ballImage.GREEN)
        return SKAction.setTexture(green, resize: true)
    }
    func setOrange() -> SKAction {
        let orange = SKTexture.init(imageNamed: ballImage.ORANGE)
        return SKAction.setTexture(orange, resize: true)
    }
    func setRed() -> SKAction {
        let red = SKTexture.init(imageNamed: ballImage.RED)
        return SKAction.setTexture(red, resize: true)
    }
}
