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
    var itemBall = ItemBall()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.view?.addSubview(headerView)
        countdownView.start()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    override func updateScore() {
        super.updateScore()
        headerView.scoreLabel.text = String(score)
    }
    
    //自陣にボールが入ったらゲームオーバーとします
    override func tballComesInTouchArea(_ node: SKSpriteNode) {
        super.tballComesInTouchArea(node)
        self.isFin = true
        self.finish()
    }
    
    override func collision(firstBody: SKPhysicsBody, secondBody: SKPhysicsBody, targetId: Int, num: Int) {
        let canRemove = (num == 1 || playerBall.isGold(firstBody.node!))
        if firstBody.categoryBitMask & ballCategory != 0 &&
            secondBody.categoryBitMask & targetBallCategory != 0 {
            if canRemove {
                updateComboCount(firstBody.node!, tnode: secondBody.node!)
                removeTargetBall(secondBody.node!, id: targetId)
                updateScore()
            } else {
                changeTargetBall(firstBody.node!, tBall: secondBody.node!, id: targetId)
            }
            if !playerBall.isGold(firstBody.node!) {
                firstBody.node?.removeFromParent()
            }
        }
    }
    
}
