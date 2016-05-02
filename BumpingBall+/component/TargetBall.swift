//
//  TargetBall.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/04.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

struct TargetBall {
    var ball = SKSpriteNode()
    var ballScale = CGFloat(0.6)
    var dx = 1.0
    var dy = 1.0
    let childBall = SKNode()
    
    init() {
        self.ball.alpha = 0.0 //フェードインのため.
        
        //0~4までのランダムな値を取得する
        let randNum = Int(arc4random_uniform(4))
        
        //0~2までのランダムな値を取得する
        let randNumDetail = Int(arc4random_uniform(2))
        var hasNumber = false
        if randNumDetail==0 {
            hasNumber = true
        }
        
        switch randNum {
        case BallType.BLUE.rawValue:
            self.ball = SKSpriteNode(imageNamed: ballImage.BLUE)
            break
        case BallType.GREEN.rawValue:
            self.ball = SKSpriteNode(imageNamed: ballImage.GREEN)
            self.dx = 0.8
            self.dy = 0.8
            self.ballScale = 0.8
            break
        case BallType.ORANGE.rawValue:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ORANGE)
            self.dx = 0.6
            self.dy = 0.6
            self.ballScale = 1.1
            break
        case BallType.RED.rawValue:
            self.ball =  SKSpriteNode(imageNamed: ballImage.RED)
            self.dx = 0.4
            self.dy = 0.4
            self.ballScale = 1.4
            break
        default:
            break
        }
        
        
        //      ボールのスピードを上げます.
        let difficulty = Difficulty()
        let speed = difficulty.getAccelerationSpped()
        self.dx += speed
        self.dy += speed
        
        self.ball.setScale(self.ballScale)
        
        self.ball.name = "t_ball"//名前をつけるのはインスタンス化した後
        self.ball.userData = NSMutableDictionary()
        self.ball.userData?.setValue(1, forKey: "num")
        self.ball.userData?.setValue(randNum, forKey: "id")
        self.ball.userData?.setValue(self.dx, forKey: "dx")
        self.ball.userData?.setValue(self.dy, forKey: "dy")
        
        if hasNumber {
            changeToHasNumberBall(randNum)
        }
        
        //衝突判定用の物理演算
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width / 2.0)
        self.ball.physicsBody?.affectedByGravity = false
        self.ball.physicsBody?.dynamic = true
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:2.0)
        self.ball.runAction(SKAction.repeatActionForever(action))
        
    }
    
    mutating func setCategory(myCat: UInt32, targetCat: UInt32) {
        self.ball.physicsBody?.categoryBitMask = myCat
        self.ball.physicsBody?.contactTestBitMask = targetCat
    }
    
    mutating func setScreenFit(var posX: UInt) -> UInt {
        let halfSize = Int(self.ball.size.width/2)
        
        //        左に見きれてしまうケース.
        if posX < UInt(halfSize) {
            posX = UInt(halfSize)
        }
        
        //        右に見きれてしまうケース.
        let sizePlusPosX = Int(posX) + halfSize
        if sizePlusPosX > Int(define.WIDTH) {
            posX = UInt(Int(define.WIDTH) - halfSize)
        }
        return posX
    }
    
    mutating func changeToHasNumberBall(randNum: Int) {
        var texture = SKTexture.init()
        var num = 1
        switch randNum {
        case BallType.BLUE.rawValue:
            texture = SKTexture.init(imageNamed: ballImage.BLUE_5)
            num = 5
            break
        case BallType.GREEN.rawValue:
            texture = SKTexture.init(imageNamed: ballImage.GREEN_3)
            num = 3
            break
        case BallType.ORANGE.rawValue:
            texture = SKTexture.init(imageNamed: ballImage.ORANGE_2)
            num = 2
            break
        default:
            return
        }
        let action = SKAction.setTexture(texture, resize: false)
        self.ball.runAction(action)
        self.ball.userData?.setValue(num, forKey: "num")
    }
}
