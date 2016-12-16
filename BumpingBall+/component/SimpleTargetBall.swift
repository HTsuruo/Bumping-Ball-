//
//  SimpleTargetBall.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/31.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class SimpleTargetBall {
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var ball = SKSpriteNode()
    var ballScale = CGFloat(0.6)
    let ballUtil = BallUtil()
    var dx = 1.0
    var dy = 1.0
    let childBall = SKNode()
    var randNum = 0
    var rotateDuration = 2.0
    let scaleVal = DeviceUtil.getOptionalScale(width: CGFloat.WIDTH)
    let speedVal = DeviceUtil.getOptionalSpeed(width: CGFloat.WIDTH)
    
    init() {
        self.ball.alpha = 0.0 //フェードインのため.
        
        //0~4までのランダムな値を取得する
        randNum = Int(arc4random_uniform(4))
        let num = BallType(rawValue: randNum)! as BallType
        setBall(num: num)
        setAccelSpeed()
        setUniqueName()
        self.ball.setScale(self.ballScale)
        
        self.ball.userData = NSMutableDictionary()
        self.ball.userData?.setValue(1, forKey: "num")
        self.ball.userData?.setValue(randNum, forKey: "id")
        self.ball.userData?.setValue(self.dx, forKey: "dx")
        self.ball.userData?.setValue(self.dy, forKey: "dy")
        
        setPhysicsBody()
        setRotate()
    }
    
    func setBall(num: BallType) {
        //        set ball image, dx, dy, scale.
    }
    
    func setAccelSpeed() {
        //        set accelration speed.
    }
    
    func setUniqueName() {
        //        set unique ball name.
    }
    
    func setPhysicsBody() {
        //衝突判定用の物理演算
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width / 2.0)
        self.ball.physicsBody?.affectedByGravity = false
        self.ball.physicsBody?.isDynamic = true
        self.ball.physicsBody?.restitution = 1.0
        self.ball.physicsBody?.linearDamping = 0
        self.ball.physicsBody?.friction = 0
        self.ball.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func setRotate() {
        let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration: rotateDuration)
        self.ball.run(SKAction.repeatForever(action))
    }
    
    
    func setCategory(_ myCat: UInt32, targetCat: UInt32) {
        self.ball.physicsBody?.categoryBitMask = myCat
        self.ball.physicsBody?.contactTestBitMask = targetCat
    }
    
    func setInScreen(_ posX: UInt) -> UInt {
        var posX = posX
        let halfSize = Int(self.ball.size.width/2)
        
        //        左に見きれてしまうケース.
        if posX < UInt(halfSize) {
            posX = UInt(halfSize)
        }
        
        //        右に見きれてしまうケース.
        let sizePlusPosX = Int(posX) + halfSize
        if sizePlusPosX > Int(CGFloat.WIDTH) {
            posX = UInt(Int(CGFloat.WIDTH) - halfSize)
        }
        return posX
    }
    
}
