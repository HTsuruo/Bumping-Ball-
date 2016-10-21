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
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var ball = SKSpriteNode()
    var ballScale = CGFloat(0.6)
    var dx = 1.0
    var dy = 1.0
    let childBall = SKNode()
    
    init() {
        self.ball.alpha = 0.0 //フェードインのため.
        
        //0~4までのランダムな値を取得する
        let randNum = Int(arc4random_uniform(4))
        
        var hasNumber = false
        //0~2までのランダムな値を取得する
        if !app.selectedDiffculty.isEasy() {
            let randNumDetail = Int(arc4random_uniform(2))
            if randNumDetail==0 {
                hasNumber = true
            }
        }
        
        switch randNum {
        case BallType.blue.rawValue:
            self.ball = SKSpriteNode(imageNamed: ballImage.BLUE)
            break
        case BallType.green.rawValue:
            self.ball = SKSpriteNode(imageNamed: ballImage.GREEN)
            self.dx = 0.8
            self.dy = 0.8
            self.ballScale = 0.8
            break
        case BallType.orange.rawValue:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ORANGE)
            self.dx = 0.6
            self.dy = 0.6
            self.ballScale = 1.1
            break
        case BallType.red.rawValue:
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
        let speed = difficulty.getAccelerationSpeed()
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
        self.ball.physicsBody?.isDynamic = true
        
        let action = SKAction.rotate(byAngle: CGFloat(M_PI), duration:2.0)
        self.ball.run(SKAction.repeatForever(action))
        
    }
    
    mutating func setCategory(_ myCat: UInt32, targetCat: UInt32) {
        self.ball.physicsBody?.categoryBitMask = myCat
        self.ball.physicsBody?.contactTestBitMask = targetCat
    }
    
    mutating func setScreenFit(_ posX: UInt) -> UInt {
        var posX = posX
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
    
    mutating func changeToHasNumberBall(_ randNum: Int) {
        var texture = SKTexture.init()
        var num = 1
        switch randNum {
        case BallType.blue.rawValue:
            texture = SKTexture.init(imageNamed: ballImage.BLUE_5)
            num = 5
            break
        case BallType.green.rawValue:
            texture = SKTexture.init(imageNamed: ballImage.GREEN_3)
            num = 3
            break
        case BallType.orange.rawValue:
            texture = SKTexture.init(imageNamed: ballImage.ORANGE_2)
            num = 2
            break
        default:
            return
        }
        let action = SKAction.setTexture(texture, resize: false)
        self.ball.run(action)
        self.ball.userData?.setValue(num, forKey: "num")
    }
}
