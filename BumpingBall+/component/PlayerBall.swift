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
    var ballScale: Double = 0.0
    //ここでいうballSpeedはdurationなので上に到達するまでにかかる時間
    var ballSpeed = define.BALL_INIT_SPEED
    var isFire = false
    let ballUtil = BallUtil()
    let scaleVal = DeviceUtil.getOptionalScale(width: CGFloat.WIDTH)
    
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
    
    mutating func sizeChange(reverse: Bool) {
        if !reverse {
            sizeChangeForward()
        } else {
            sizeChangeReverse()
        }
        self.ball.setScale(CGFloat(self.ballScale))
    }
    
    mutating func sizeChangeForward() {
        self.ballScale += (0.04 * scaleVal)
        sizeChange()
        if ballUtil.isInScaleOther(scale: Double(self.ballScale)) {
            setBlue()
            self.ballScale = ballUtil.getMinScale() *  scaleVal
        }
    }
    
    mutating func sizeChangeReverse() {
        self.ballScale -= (0.04 * scaleVal)
        sizeChange()
        if ballUtil.isInScaleOther(scale: Double(self.ballScale)) {
            setRed()
            self.ballScale = ballUtil.getMaxScale() * scaleVal
        }
    }
    
    mutating func sizeChange() {
        if ballUtil.isInScaleRange(name: "blue", scale: Double(self.ballScale)) {
            setBlue()
        }
        if ballUtil.isInScaleRange(name: "green", scale: Double(self.ballScale)) {
            setGreen()
        }
        if ballUtil.isInScaleRange(name: "orange", scale: Double(self.ballScale)) {
            setOrange()
        }
        if ballUtil.isInScaleRange(name: "red", scale: Double(self.ballScale)) {
            setRed()
        }
    }
    
    mutating func setBlue() {
        self.ballSpeed = define.BALL_INIT_SPEED
        self.ball.run(ballUtil.setBlue())
        self.setId(BallType.blue.rawValue)
    }
    
    mutating func setGreen() {
        self.ballSpeed = 0.7
        self.ball.run(ballUtil.setGreen())
        self.setId(BallType.green.rawValue)
    }
    
    mutating func setOrange() {
        self.ballSpeed = 0.9
        self.ball.run(ballUtil.setOrange())
        self.setId(BallType.orange.rawValue)
    }
    
    mutating func setRed() {
        self.ballSpeed = 1.1
        self.ball.run(ballUtil.setRed())
        self.setId(BallType.red.rawValue)
    }
    
    mutating func setGold() {
        self.ballSpeed = 5.0
        self.ball.run(ballUtil.setGold())
        self.setId(BallType.gold.rawValue)
        self.ball.setScale(CGFloat(2.0 * scaleVal))
    }
    
    func isGold(_ node: SKNode) -> Bool {
        let myId = node.userData?.value(forKey: "id") as? Int
        if let id = myId {
            return id == BallType.gold.rawValue
        }
        return false
    }
    
}
