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
        self.ball.userData?.setValue(true, forKey: "isItem")
        self.ball.userData?.setValue(false, forKey: "isCollision")
    }
    
    override func setBall(num: BallType) {
        switch num {
        case .blue:
            self.ball = SKSpriteNode(imageNamed: ballImage.ITEM_BLUE)
            break
        case .green:
            self.ball = SKSpriteNode(imageNamed: ballImage.ITEM_GREEN)
            break
        case .orange:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ITEM_ORANGE)
            break
        case .red:
            self.ball =  SKSpriteNode(imageNamed: ballImage.ITEM_RED)
            break
        default:
            break
        }
        self.dx = 1.5
        self.dy = 1.5
        self.ballScale = 0.7
    }
    
    override func setUniqueName() {
        self.ball.name = "item_ball"//名前をつけるのはインスタンス化した後
    }
    
    override func setRotate() {
        rotateDuration = 0.5
        super.setRotate()
    }

}
