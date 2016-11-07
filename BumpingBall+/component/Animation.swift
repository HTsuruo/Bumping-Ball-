//
//  Animation.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/13.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import Foundation
import SpriteKit

class Animation {
    
    func removeAfterAction(_ firstAction: SKAction) -> SKAction {
        let remove = SKAction.removeFromParent()
        return SKAction.sequence([firstAction, remove])
    }

    func fadeOutRemove(_ duration: Double) -> SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: duration)
        return removeAfterAction(fadeOut)
    }
    
    func moveToYFadeOut(_ fadeOut: Double, yPos: CGFloat, moveToY: Double) -> SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: fadeOut)
        let move = SKAction.moveTo(y: yPos, duration: moveToY)
        return SKAction.group([move, fadeOut]) // 同時実行するグループアクションを作る.
    }
    
    func sparkAnimation(_ node: SKNode, id: Int, scale: CGFloat) -> SKEmitterNode {
        let sparkPath = Bundle.main.path(forResource: "spark", ofType: "sks")
        let spark = NSKeyedUnarchiver.unarchiveObject(withFile: sparkPath!) as! SKEmitterNode
        spark.position = node.position
        spark.particleColorSequence = nil
        spark.particleColorBlendFactor = 1.0
        
        switch id {
        case BallType.blue.rawValue:
            spark.particleColor = ColorUtil.blue
            break
        case BallType.green.rawValue:
            spark.particleColor = ColorUtil.green
            break
        case BallType.orange.rawValue:
            spark.particleColor = ColorUtil.orange
            break
        case BallType.red.rawValue:
            spark.particleColor = ColorUtil.red
            break
        default:
            break
        }
        
        spark.setScale(scale)
        return spark
    }
    
    func launchNode(_ point: CGPoint, id: Int) -> SKNode {
        var node: SKSpriteNode! = nil
        let type = BallType(rawValue: id)! as BallType
        
        switch type {
        case .blue:
            node  = SKSpriteNode(imageNamed: "circle_blue")
            break
        case .green:
            node  = SKSpriteNode(imageNamed: "circle_green")
            break
        case .orange:
            node  = SKSpriteNode(imageNamed: "circle_orange")
            break
        case .red:
            node  = SKSpriteNode(imageNamed: "circle_red")
            break
        default:
            return node
        }
        node.position = point
        node.xScale = 0.1
        node.yScale = 0.1
        return node
    }
    
    func destroyAnimation() -> SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scale = SKAction.scale(to: 1.3, duration: 0.5)
        let action = SKAction.group([fadeOut, scale])
        return removeAfterAction(action)
    }
    
    func launchAnimation() -> SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scale = SKAction.scale(to: 1.0, duration: 0.5)
        let action = SKAction.group([fadeOut, scale])
        return removeAfterAction(action)
    }
    
    func absorptionAnimation() -> SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scale = SKAction.scale(to: 0.0, duration: 0.5)
        let action = SKAction.group([fadeOut, scale])
        return removeAfterAction(action)
    }
    
    func chargeMeterAnimation(_ duration: Double) -> SKAction {
        let gold = SKAction.colorize(with: ColorUtil.gold, colorBlendFactor: 1.0, duration: duration)
        let orange = SKAction.colorize(with: ColorUtil.orange, colorBlendFactor: 1.0, duration: duration)
        let sequence  = SKAction.sequence([gold, orange])
        let foreverChange  = SKAction.repeatForever(sequence)
        return foreverChange
    }
    
    func goldenModeBk() -> SKAction {
        let color1 = SKAction.colorize(with: ColorUtil.goldbk, colorBlendFactor: 1.0, duration: 0.3)
        let color2 = SKAction.colorize(with: UIColor.clear, colorBlendFactor: 1.0, duration: 0.3)
        let sequence  = SKAction.sequence([color1, color2])
        let foreverChange  = SKAction.repeatForever(sequence)
        return foreverChange
    }
    
    func backgroundAnimation() -> SKEmitterNode {
        let emitterPath = Bundle.main.path(forResource: "bk", ofType: "sks")
        let node = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath!) as! SKEmitterNode
        node.particleTexture = SKTexture(image: UIImage(named: "snow")!)
        node.particleColorSequence = nil
        node.particleColor = UIColor.white
        node.particleColorBlendFactor = 1.0
        //node.particleTexture = SKTexture(image: UIImage(named: "star")!)
        node.position = CGPoint(x: CGFloat.CENTER.x, y: CGFloat.HEIGHT)
        return node
    }
    
    func itemBallLaunchAnimation(_ node: SKNode) -> SKAction {
        node.physicsBody?.isDynamic = false
        let down = SKAction.moveTo(y: node.position.y-30, duration: Double(0.15))
        let delay = SKAction.wait(forDuration: 0.1)
        let up = SKAction.moveTo(y: CGFloat.HEIGHT, duration: Double(0.1))
        return SKAction.sequence([down, delay, up])
    }
    
    func scaleAnimation(_ node: SKNode) -> SKAction {
        let originalScale = node.xScale
        let bigger = SKAction.scale(to: originalScale + 0.3, duration: Double(0.1))
        let delay = SKAction.wait(forDuration: 0.1)
        let normal = SKAction.scale(to: originalScale, duration: Double(0.1))
        return SKAction.sequence([bigger, delay, normal])
    }
    
    func scaleAnimation(_ node: SKSpriteNode) -> SKAction {
        let originalScale = node.xScale
        let bigger = SKAction.scale(to: originalScale + 0.3, duration: Double(0.15))
        let delay = SKAction.wait(forDuration: 0.15)
        let normal = SKAction.scale(to: originalScale, duration: Double(0.15))
        return SKAction.sequence([bigger, delay, normal])
    }
    
    func blinkAnimation(_ node: SKNode) -> SKAction {
        let alphain = SKAction.fadeAlpha(to: 0.3, duration: 0.1)
        let delay = SKAction.wait(forDuration: 0.1)
        let alphaout = SKAction.fadeAlpha(by: 1.0, duration: 0.1)
        return SKAction.sequence([alphain, delay, alphaout])
    }
    
}
