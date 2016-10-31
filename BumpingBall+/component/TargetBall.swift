//
//  TargetBall.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/04.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class TargetBall: SimpleTargetBall {
    
    override init() {
        super.init()
        
        // easy mode以外
        if !app.selectedDiffculty.isEasy() {
            if hasNumber() {
                changeToHasNumberBall(randNum)
            }
        }
    }
    
    override func setBall(num: BallType) {
        switch num {
        case .blue:
            self.ball = SKSpriteNode(imageNamed: ballImage.BLUE)
            break
        case .green:
            self.ball = SKSpriteNode(imageNamed: ballImage.GREEN)
            self.dx = 0.8
            self.dy = 0.8
            self.ballScale = 0.8
            break
        case .orange:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ORANGE)
            self.dx = 0.6
            self.dy = 0.6
            self.ballScale = 1.1
            break
        case .red:
            self.ball =  SKSpriteNode(imageNamed: ballImage.RED)
            self.dx = 0.4
            self.dy = 0.4
            self.ballScale = 1.4
            break
        default:
            break
        }
    }
    
    override func setAccelSpeed() {
        let difficulty = Difficulty()
        let speed = difficulty.getAccelerationSpeed()
        self.dx += speed
        self.dy += speed
    }
    
    override func setUniqueName() {
        self.ball.name = "t_ball"//名前をつけるのはインスタンス化した後
    }
    
    func hasNumber() -> Bool {
        //0~2までのランダムな値を取得する
        let randNumDetail = Int(arc4random_uniform(2))
        if randNumDetail==0 {
            return true
        }
        return false
    }
    
    
    func changeToHasNumberBall(_ randNum: Int) {
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
