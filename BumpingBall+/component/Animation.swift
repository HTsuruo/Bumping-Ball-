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
            spark.particleColor = colorUtil.blue
            break
        case BallType.green.rawValue:
            spark.particleColor = colorUtil.green
            break
        case BallType.orange.rawValue:
            spark.particleColor = colorUtil.orange
            break
        case BallType.red.rawValue:
            spark.particleColor = colorUtil.red
            break
        default:
            break
        }
        
        spark.setScale(scale)
        return spark
    }
    
    func launchAnimation(_ node: SKNode, id: Int) -> SKEmitterNode {
        let launchPath = Bundle.main.path(forResource: "launch", ofType: "sks")
        let launch = NSKeyedUnarchiver.unarchiveObject(withFile: launchPath!) as! SKEmitterNode
        launch.position.x = node.position.x
        launch.position.y = node.position.y
        launch.particleColorSequence = nil
        launch.particleColorBlendFactor = 1.0
        
        var launchScale: CGFloat = 1.0
        
        switch id {
        case BallType.blue.rawValue:
            launch.particleColor = colorUtil.blue
            break
        case BallType.green.rawValue:
            launch.particleColor = colorUtil.green
            launchScale = 1.1
            break
        case BallType.orange.rawValue:
            launch.particleColor = colorUtil.orange
            launchScale = 1.2
            break
        case BallType.red.rawValue:
            launch.particleColor = colorUtil.red
            launchScale = 1.3
            break
        case BallType.gold.rawValue:
            launch.particleColor = colorUtil.gold
            launchScale = 4.0
            break
        default:
            break
        }
        launch.setScale(launchScale)
        return launch
    }
    
    func chargeMeterAnimation(_ duration: Double) -> SKAction {
        let gold = SKAction.colorize(with: colorUtil.gold, colorBlendFactor: 1.0, duration: duration)
        let orange = SKAction.colorize(with: colorUtil.orange, colorBlendFactor: 1.0, duration: duration)
        let sequence  = SKAction.sequence([gold, orange])
        let foreverChange  = SKAction.repeatForever(sequence)
        return foreverChange
    }
    
}
