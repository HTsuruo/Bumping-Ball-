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
    let animation = Animation()
    
    override func didMove(to view: SKView) {
        createPlayerBall()
//        changeBkColor()
        self.backgroundColor = UIColor.clear
        
        let node  = SKSpriteNode(imageNamed: "circle_blue")
        node.position = CGFloat.CENTER
        self.addChild(node)
        
        let fadeOut = SKAction.fadeOut(withDuration: 3.0)
        let scale = SKAction.scale(to: 3.0, duration: 3.0)
        let action = SKAction.group([fadeOut, scale])
//        let sequence = animation.removeAfterAction(action)
        let forever  = SKAction.repeatForever(action)
        node.run(forever)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if last == nil {
            last = currentTime
        }
        
        if last + 3 <= currentTime {
            last = currentTime
        }
    }

    func changeBkColor() {
        let color1 = SKAction.colorize(with: ColorUtil.main, colorBlendFactor: 1.0, duration: 4)
        let color2 = SKAction.colorize(with: ColorUtil.green, colorBlendFactor: 1.0, duration: 4)
        let color3 = SKAction.colorize(with: ColorUtil.black, colorBlendFactor: 1.0, duration: 4)
        let sequence  = SKAction.sequence([color1, color2, color3])
        let foreverChange  = SKAction.repeatForever(sequence)
        self.run(foreverChange)
    }
    
    fileprivate func createPlayerBall() {
       let ball = SKSpriteNode(imageNamed: ballImage.RED)
       ball.position = CGPoint(x: 300, y: 100)
       ball.alpha = 0.2
       self.addChild(ball)
       let action = SKAction.rotate(byAngle: CGFloat(90 * M_PI / 180), duration: 1)
       let foreverAction  = SKAction.repeatForever(action)
//       let actionx = SKAction.group([action1,action2])
       ball.run(foreverAction)
    }
    
}
