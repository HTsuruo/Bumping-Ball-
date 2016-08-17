//
//  GameScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/11.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit
import UIKit

class TopScene: SKScene, SKPhysicsContactDelegate {
    var last: CFTimeInterval!
    
    override func didMoveToView(view: SKView) {
        createPlayerBall()
        changeBkColor()
    }
    
    override func update(currentTime: CFTimeInterval) {
    }

    func changeBkColor() {
        let color1 = SKAction.colorizeWithColor(colorUtils.navy, colorBlendFactor: 1.0, duration: 4)
        let color2 = SKAction.colorizeWithColor(colorUtils.green, colorBlendFactor: 1.0, duration: 4)
        let color3 = SKAction.colorizeWithColor(colorUtils.black, colorBlendFactor: 1.0, duration: 4)
        let sequence  = SKAction.sequence([color1, color2, color3])
        let foreverChange  = SKAction.repeatActionForever(sequence)
        self.runAction(foreverChange)
    }
    
    func changeBk() {
        let nextScene = PlayScene()
        nextScene.size = self.size
        let transition = SKTransition.crossFadeWithDuration(2)
        self.view?.presentScene(nextScene, transition: transition)
    }
    
    private func createPlayerBall() {
       let ball = SKSpriteNode(imageNamed: ballImage.RED)
       ball.position = CGPointMake(300, 100)
       ball.alpha = 0.8
       self.addChild(ball)
       let action = SKAction.rotateByAngle(CGFloat(90 * M_PI / 180), duration: 1)
       let foreverAction  = SKAction.repeatActionForever(action)
//       let actionx = SKAction.group([action1,action2])
       ball.runAction(foreverAction)
    }

}
