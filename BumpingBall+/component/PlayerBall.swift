//
//  Ball.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/02.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

struct PlayerBall {
    var id = 0
    var ball = SKSpriteNode(imageNamed: ballImage.BLUE)
    var ballScale = define.BALL_INIT_SCALE
    //ここでいうballSpeedはdurationなので上に到達するまでにかかる時間
    var ballSpeed = define.BALL_INIT_SPEED
    var isFire = false
    
    init() {
        self.ball.name = "ball"
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width / 2.0)
        self.ball.physicsBody?.affectedByGravity = false
        self.ball.physicsBody?.dynamic = false
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:0.8)
        self.ball.runAction(SKAction.repeatActionForever(action))
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
    
    mutating func sizeChange() {
        let ballUtil = BallUtils()
        self.ballScale += 0.025
        if self.ballScale < 0.8 {
            self.ballSpeed = define.BALL_INIT_SPEED
            self.ball.runAction(ballUtil.setBlue())
            self.setId(BallType.BLUE.rawValue)
        } else if self.ballScale < 1.1 {
            self.ballSpeed = 0.75
            self.ball.runAction(ballUtil.setGreen())
            self.setId(BallType.GREEN.rawValue)
        } else if self.ballScale < 1.4 {
            self.ballSpeed = 1.0
            self.ball.runAction(ballUtil.setOrange())
            self.setId(BallType.ORANGE.rawValue)
        } else if self.ballScale < 1.7 {
            self.ballSpeed = 1.25
            self.ball.runAction(ballUtil.setRed())
            self.setId(BallType.RED.rawValue)
        } else {
            self.ballScale = define.BALL_INIT_SCALE
            self.ballSpeed = define.BALL_INIT_SPEED
            self.ball.runAction(ballUtil.setBlue())
            self.setId(BallType.BLUE.rawValue)
        }
        self.ball.setScale(self.ballScale)
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
    
    //   跳ね返り処理
    func setRebound(node: SKSpriteNode) {
        let halfSize = Int(node.size.width/2)
        var screenCollision = false
        
        if node.position.x < CGFloat(halfSize) {
            node.position.x = CGFloat(halfSize)
            screenCollision = true
        }
        
        if node.position.x > define.WIDTH - CGFloat(halfSize) {
            node.position.x = define.WIDTH - CGFloat(halfSize)
            screenCollision = true
        }
        
        let posX: UInt = UInt(node.position.x)
        var dx = node.userData?.valueForKey("dx") as! CGFloat
    
        if posX < UInt(halfSize) {
            screenCollision = true
        }
        let sizePlusPosX = Int(posX) + halfSize
        if sizePlusPosX > Int(define.WIDTH) {
            screenCollision = true
        }
        
        if screenCollision {
            dx *= -1
        }
        node.userData?.setValue(dx, forKey: "dx")
    }
    
}
