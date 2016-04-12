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

    func fadeOutRemove(duration: Double) -> SKAction {
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let remove = SKAction.removeFromParent()
        return SKAction.sequence([fadeOut, remove])
    }
    
    func sparkAnimation(node: SKNode, id: Int) -> SKEmitterNode {
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
        
        spark.setScale(0.5)
        return spark
    }
    
}
