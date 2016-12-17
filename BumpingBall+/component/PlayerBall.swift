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
    //ここでいうballSpeedはdurationなので上に到達するまでにかかる時間
    var ballSpeed = define.BALL_INIT_SPEED
    var isFire = false
    let ballUtil = BallUtil()
    let scaleVal = DeviceUtil.getOptionalScale(width: CGFloat.WIDTH)
    let speedVal = DeviceUtil.getOptionalSpeed(width: CGFloat.WIDTH)
    let increaseVal = DeviceUtil.getIncreaseScale(width: CGFloat.WIDTH)
    var ballScale: Double = 0.0
    
    init() {
        self.ball.name = "ball"
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width / 2.0)
        self.ball.physicsBody?.affectedByGravity = false
        self.ball.physicsBody?.isDynamic = false
        let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration:0.8)
        self.ball.run(SKAction.repeatForever(action))
        self.ballScale = ballUtil.getMinScale() * self.scaleVal
        setInitScale()
    }
    
    mutating func setInitScale() {
        self.ballScale = ballUtil.getMinScale()
        self.ball.setScale(CGFloat(self.ballScale))
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
        self.ballScale += DeviceUtil.getIncreaseScale(width: CGFloat.WIDTH)
        print(self.ballScale)
        sizeChange()
        if ballUtil.isInScaleOverMax(scale: Double(self.ballScale)) {
            setBlue()
            self.ballScale = ballUtil.getMinScale() *  scaleVal
        }
    }
    
    mutating func sizeChangeReverse() {
        self.ballScale -= DeviceUtil.getIncreaseScale(width: CGFloat.WIDTH)
        sizeChange()
        if ballUtil.isInScaleOverMin(scale: Double(self.ballScale)) {
            setRed()
            self.ballScale = ballUtil.getMaxScale() * scaleVal
            return
        }
    }
    
    mutating func sizeChange() {
        if ballUtil.isInScaleRange(name: "blue", scale: Double(self.ballScale)) {
            setBlue()
            return
        }
        if ballUtil.isInScaleRange(name: "green", scale: Double(self.ballScale)) {
            setGreen()
            return
        }
        if ballUtil.isInScaleRange(name: "orange", scale: Double(self.ballScale)) {
            setOrange()
            return
        }
        if ballUtil.isInScaleRange(name: "red", scale: Double(self.ballScale)) {
            setRed()
            return
        }
    }
    
    mutating func setBlue() {
        self.ballSpeed = CGFloat(ballUtil.getPlayerBallSpeed(name: "blue"))
        self.ball.run(ballUtil.setBlue())
        self.setId(BallType.blue.rawValue)
    }
    
    mutating func setGreen() {
        self.ballSpeed = CGFloat(ballUtil.getPlayerBallSpeed(name: "green"))
        self.ball.run(ballUtil.setGreen())
        self.setId(BallType.green.rawValue)
    }
    
    mutating func setOrange() {
        self.ballSpeed = CGFloat(ballUtil.getPlayerBallSpeed(name: "orange"))
        self.ball.run(ballUtil.setOrange())
        self.setId(BallType.orange.rawValue)
    }
    
    mutating func setRed() {
        self.ballSpeed = CGFloat(ballUtil.getPlayerBallSpeed(name: "red"))
        self.ball.run(ballUtil.setRed())
        self.setId(BallType.red.rawValue)
    }
    
    mutating func setGold() {
        self.ballSpeed = CGFloat(ballUtil.getPlayerBallSpeed(name: "gold"))
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
