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
    
    func removeAfterAction(firstAction: SKAction) -> SKAction {
        let remove = SKAction.removeFromParent()
        return SKAction.sequence([firstAction, remove])
    }

    func fadeOutRemove(duration: Double) -> SKAction {
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        return removeAfterAction(fadeOut)
    }
    
    func moveToYFadeOut(fadeOut: Double, yPos: CGFloat, moveToY: Double) -> SKAction {
        let fadeOut = SKAction.fadeOutWithDuration(fadeOut)
        let move = SKAction.moveToY(yPos, duration: moveToY)
        return SKAction.group([move, fadeOut]) // 同時実行するグループアクションを作る.
    }
    
    func sparkAnimation(node: SKNode, id: Int, scale: CGFloat) -> SKEmitterNode {
        let sparkPath = NSBundle.mainBundle().pathForResource("spark", ofType: "sks")
        let spark = NSKeyedUnarchiver.unarchiveObjectWithFile(sparkPath!) as! SKEmitterNode
        spark.position = node.position
        spark.particleColorSequence = nil
        spark.particleColorBlendFactor = 1.0
        
        switch id {
        case BallType.BLUE.rawValue:
            spark.particleColor = colorUtils.blue
            break
        case BallType.GREEN.rawValue:
            spark.particleColor = colorUtils.green
            break
        case BallType.ORANGE.rawValue:
            spark.particleColor = colorUtils.orange
            break
        case BallType.RED.rawValue:
            spark.particleColor = colorUtils.red
            break
        default:
            break
        }
        
        spark.setScale(scale)
        return spark
    }
    
    func launchAnimation(node: SKNode, id: Int) -> SKEmitterNode {
        let launchPath = NSBundle.mainBundle().pathForResource("launch", ofType: "sks")
        let launch = NSKeyedUnarchiver.unarchiveObjectWithFile(launchPath!) as! SKEmitterNode
        launch.position.x = node.position.x
        launch.position.y = node.position.y
        launch.particleColorSequence = nil
        launch.particleColorBlendFactor = 1.0
        
        var launchScale: CGFloat = 1.0
        
        switch id {
        case BallType.BLUE.rawValue:
            launch.particleColor = colorUtils.blue
            break
        case BallType.GREEN.rawValue:
            launch.particleColor = colorUtils.green
            launchScale = 1.1
            break
        case BallType.ORANGE.rawValue:
            launch.particleColor = colorUtils.orange
            launchScale = 1.2
            break
        case BallType.RED.rawValue:
            launch.particleColor = colorUtils.red
            launchScale = 1.3
            break
        case BallType.GOLD.rawValue:
            launch.particleColor = colorUtils.gold
            launchScale = 4.0
            break
        default:
            break
        }
        launch.setScale(launchScale)
        return launch
    }
    
    func chargeMeterAnimation(duration: Double) -> SKAction{
        let gold = SKAction.colorizeWithColor(colorUtils.gold, colorBlendFactor: 1.0, duration: duration)
        let orange = SKAction.colorizeWithColor(colorUtils.orange, colorBlendFactor: 1.0, duration: duration)
        let sequence  = SKAction.sequence([gold, orange])
        let foreverChange  = SKAction.repeatActionForever(sequence)
        return foreverChange
    }
    
}
