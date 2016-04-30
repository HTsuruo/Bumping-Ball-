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
        print("here is top view.")
        changeBkColor()
    }
    
    override func update(currentTime: CFTimeInterval) {
        if last == nil {
            last = currentTime
        }
        //         3秒毎にtargetBallを作成する.
        if last + 7 <= currentTime {
            last = currentTime
        }
    }
    
    func changeBkColor() {
        let color1 = SKAction.colorizeWithColor(colorUtils.orange, colorBlendFactor: 1.0, duration: 4)
        let color2 = SKAction.colorizeWithColor(colorUtils.green, colorBlendFactor: 1.0, duration: 4)
        let color3 = SKAction.colorizeWithColor(colorUtils.blue, colorBlendFactor: 1.0, duration: 4)
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

}