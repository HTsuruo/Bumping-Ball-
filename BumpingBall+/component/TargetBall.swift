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
    var ballScale = define.BALL_INIT_SCALE
    var ballSpeed = define.BALL_INIT_SPEED
    let childBall = SKNode()
    
    init() {
        self.ball.name = "t_ball"
        self.ball.alpha = 0.0 //フェードインのため.
        //0~4までのランダムな値を取得する
        let randNum = Int(arc4random_uniform(4))
        switch randNum {
        case BallType.BLUE.rawValue:
            self.ball = SKSpriteNode(imageNamed: ballImage.BLUE)
        case BallType.GREEN.rawValue:
            self.ball =  SKSpriteNode(imageNamed: ballImage.GREEN)
        case BallType.ORANGE.rawValue:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ORANGE)
        case BallType.RED.rawValue:
            self.ball =  SKSpriteNode(imageNamed: ballImage.RED)
        default:
            break
        }
        
        self.ball.userData = NSMutableDictionary()
        self.ball.userData?.setValue(randNum, forKey: "id")
        
        //衝突判定用の物理演算
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width / 2.0)
    }
    
    mutating func setCategory(myCat: UInt32, targetCat: UInt32) {
        self.ball.physicsBody?.categoryBitMask = myCat
        self.ball.physicsBody?.contactTestBitMask = targetCat
    }
}
