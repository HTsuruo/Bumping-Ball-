//
//  GameScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/11.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit
import UIKit

class FinishScene: SKScene, SKPhysicsContactDelegate {
    var last: CFTimeInterval!
    
    override func didMoveToView(view: SKView) {
        print("here is finish view.")
    }
    
    override func update(currentTime: CFTimeInterval) {
        if last == nil {
            last = currentTime
        }
        //         3秒毎にtargetBallを作成する.
        if last + 3 <= currentTime {
            last = currentTime
        }
    }
    
    func changeBkColor() {
        let nextScene = PlayScene()
        nextScene.size = self.size
        let transition = SKTransition.crossFadeWithDuration(2)
        self.view?.presentScene(nextScene, transition: transition)
    }

}
