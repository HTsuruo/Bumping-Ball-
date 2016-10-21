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
        self.ball.physicsBody?.isDynamic = false
        let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration:0.8)
        self.ball.run(SKAction.repeatForever(action))
    }
    
    mutating func setLocation(_ posX: CGFloat, posY: CGFloat) {
        self.ball.position.x = posX
        self.ball.position.y = posY
    }
    
    mutating func setCategory(_ myCat: UInt32, targetCat: UInt32) {
        self.ball.physicsBody?.categoryBitMask = myCat
        self.ball.physicsBody?.contactTestBitMask = targetCat
    }
    
    func setId(_ id: Int) {
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
            self.ball.run(ballUtil.setBlue())
            self.setId(BallType.blue.rawValue)
        } else if self.ballScale < 1.1 {
            self.ballSpeed = 0.75
            self.ball.run(ballUtil.setGreen())
            self.setId(BallType.green.rawValue)
        } else if self.ballScale < 1.4 {
            self.ballSpeed = 1.0
            self.ball.run(ballUtil.setOrange())
            self.setId(BallType.orange.rawValue)
        } else if self.ballScale < 1.7 {
            self.ballSpeed = 1.25
            self.ball.run(ballUtil.setRed())
            self.setId(BallType.red.rawValue)
        } else {
            self.ballScale = define.BALL_INIT_SCALE
            self.ballSpeed = define.BALL_INIT_SPEED
            self.ball.run(ballUtil.setBlue())
            self.setId(BallType.blue.rawValue)
        }
        self.ball.setScale(self.ballScale)
    }
    
    mutating func setGoldBall() {
        let ballUtil = BallUtils()
        self.ballSpeed = 3.5
        self.ball.run(ballUtil.setGold())
        self.setId(BallType.gold.rawValue)
        self.ball.setScale(2.0)
    }
    
    func isGold(_ node: SKNode) -> Bool {
        let myId = node.userData?.value(forKey: "id")
        return myId as! Int == BallType.gold.rawValue
    }
    
}
