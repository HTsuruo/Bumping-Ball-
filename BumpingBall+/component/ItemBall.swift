//
//  ItemBall.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/31.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class ItemBall: SimpleTargetBall {
    
    override init() {
        super.init()
    }
    
    override func setBall(num: BallType) {
        switch num {
        case .blue:
            self.ball = SKSpriteNode(imageNamed: ballImage.ITEM_BLUE)
            self.dx = 1.5
            self.dy = 1.5
            break
        case .green:
            self.ball = SKSpriteNode(imageNamed: ballImage.ITEM_GREEN)
            self.dx = 1.3
            self.dy = 1.3
            self.ballScale = 0.8
            break
        case .orange:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ITEM_ORANGE)
            self.dx = 1.1
            self.dy = 1.1
            self.ballScale = 1.1
            break
        case .red:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ITEM_RED)
            self.dx = 0.9
            self.dy = 0.9
            self.ballScale = 1.3
            break
        default:
            break
        }
    }
    
    override func setAccelSpeed() {
//        let difficulty = Difficulty()
//        let speed = difficulty.getAccelerationSpeed()
//        self.dx += speed
//        self.dy += speed
    }
    
    override func setUniqueName() {
        self.ball.name = "item_ball"//名前をつけるのはインスタンス化した後
    }
    
    override func setRotate() {
        rotateDuration = 0.5
        super.setRotate()
    }

}
