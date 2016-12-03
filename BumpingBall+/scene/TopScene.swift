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
//        changeBkColor()
        self.backgroundColor = UIColor.clear
        createCenterCircle()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if last == nil {
            last = currentTime
        }
        
        if last + 1.0 <= currentTime {
            last = currentTime
            createRandomCircle()
        }
    }
    
    func createCenterCircle() {
        let node  = SKSpriteNode(imageNamed: "circle_blue")
        node.position = CGFloat.CENTER
        self.addChild(node)
        let action = animation.circleAnimation(scale: 2.5, duration: 3.0)
        node.run(action)
    }
    
    func createRandomCircle() {
        let rand = arc4random_uniform(4)
        var node: SKSpriteNode! = nil
        switch rand {
        case 0:
            node = SKSpriteNode(imageNamed: "circle_blue")
            break
        case 1:
            node = SKSpriteNode(imageNamed: "circle_green")
            break
        case 2:
            node = SKSpriteNode(imageNamed: "circle_orange")
            break
        case 3:
            node = SKSpriteNode(imageNamed: "circle_red")
            break
        default:
            node = SKSpriteNode(imageNamed: "circle_blue")
            break
        }
        let xPos = arc4random_uniform(UInt32(CGFloat.WIDTH))
        let yPos = arc4random_uniform(UInt32(CGFloat.HEIGHT))
        node.position = CGPoint(x: Double(xPos), y: Double(yPos))
        let scaleInit = arc4random_uniform(20)//0.0~2.0
        let sInit = Double(scaleInit + 1)
        node.xScale = CGFloat(sInit * 0.1)
        node.yScale = CGFloat(sInit * 0.1)
        node.alpha = 0.0
        self.addChild(node)
        let scaleFin = arc4random_uniform(10)//1.0~2.0
        let sFin = Double(scaleFin+1)
        let duration = arc4random_uniform(5)
        let action = animation.circleAnimation(scale: 1.0 + CGFloat(sFin*0.1), duration: 1.5 + Double(duration))
        node.run(action)
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
