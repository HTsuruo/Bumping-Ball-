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
        if app.selectedDiffculty.canCreateHasNumber() {
            if hasNumber() {
                changeHasNumberBall(randNum)
            }
        }
    }
    
    override func setBall(num: BallType) {
        var color = "blue"
        switch num {
        case .blue:
            self.ball = SKSpriteNode(imageNamed: ballImage.BLUE)
            break
        case .green:
            self.ball = SKSpriteNode(imageNamed: ballImage.GREEN)
            color = "green"
            break
        case .orange:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ORANGE)
            color = "orange"
            break
        case .red:
            self.ball =  SKSpriteNode(imageNamed: ballImage.RED)
            color = "red"
            break
        default:
            break
        }
        
        self.ballScale = ballUtil.getScale(name: color)
        let speed = ballUtil.getTargetBallSpeed(name: color)
        self.dx = speed
        self.dy = speed
        self.ballScale *= CGFloat(scaleVal)
    }
    
    override func setAccelSpeed() {
        let speed = app.accelation
        self.dx += speed
        self.dy += speed
    }
    
    override func setUniqueName() {
        self.ball.name = "t_ball"//名前をつけるのはインスタンス化した後
    }
    
    func hasNumber() -> Bool {
        //0~2までのランダムな値を取得する
        let randNumDetail = Int(arc4random_uniform(3))
        if randNumDetail==0 {
            return true
        }
        return false
    }
    
    func changeDevilBall(id: Int) {
        self.ball.userData?.setValue(id, forKey: "id")
        let rand = Int(arc4random_uniform(2))
        self.ball.userData?.setValue(rand+1, forKey: "num")
        let type = BallType(rawValue: id)! as BallType
        var texture = SKTexture.init()
        switch type {
        case .blue:
            texture = SKTexture.init(imageNamed: ballImage.DEVIL_BLUE)
            break
        case .green:
            texture = SKTexture.init(imageNamed: ballImage.DEVIL_GREEN)
            break
        case .orange:
            texture = SKTexture.init(imageNamed: ballImage.DEVIL_ORANGE)
            break
        case .red:
            texture = SKTexture.init(imageNamed: ballImage.DEVIL_RED)
            break
        default:
            break
        }
        
        self.ballScale = CGFloat(1.0 * scaleVal)
        self.ball.setScale(self.ballScale)
        let action = SKAction.setTexture(texture, resize: false)
        self.ball.run(action)
    }
    
    
    func changeHasNumberBall(_ randNum: Int) {
        var texture = SKTexture.init()
        var num = 1
        switch randNum {
        case BallType.blue.rawValue:
            let rand = Int(arc4random_uniform(2))
            if rand == 0 {
                texture = SKTexture.init(imageNamed: ballImage.BLUE_5)
                num = 5
            } else {
                texture = SKTexture.init(imageNamed: ballImage.BLUE_3)
                num = 3
            }
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
