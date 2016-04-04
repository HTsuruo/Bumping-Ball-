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
    var id = 0
    var ball = SKSpriteNode(imageNamed: ballImage.BLUE)
    var ballScale = define.BALL_INIT_SCALE
    var ballSpeed = define.BALL_INIT_SPEED
    var isFire = false
    
    init() {
        self.ball.name = "ball"
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width / 2.0)
        self.ball.physicsBody?.affectedByGravity = false
        self.ball.physicsBody?.dynamic = false
    }
    
    mutating func setLocation(posX: CGFloat, posY: CGFloat) {
        self.ball.position.x = posX
        self.ball.position.y = posY
    }
    
    mutating func setCategory(myCat: UInt32, targetCat: UInt32) {
        self.ball.physicsBody?.categoryBitMask = myCat
        self.ball.physicsBody?.contactTestBitMask = targetCat
    }
    
    func setId(id: Int) {
        self.ball.userData = NSMutableDictionary()
        self.ball.userData?.setValue(id, forKey: "id")
        self.ball.userData?.setValue(false, forKey: "isFire")
    }
    
    func setIsFire() {
        self.ball.userData?.setValue(true, forKey: "isFire")
    }
    
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
