//
//  OnePlayScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class OnePlayScene: BaseScene {
    
    let headerView = HeaderView()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.view?.addSubview(headerView)
        countdownView.start()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
    }
    
    override func updateScore() {
        super.updateScore()
        headerView.scoreLabel.text = String(score)
    }
}
