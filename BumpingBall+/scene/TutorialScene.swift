//
//  TutorialScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/10.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialScene: BaseScene {
    
    var tutorialNumber = 0
    var nextButton = SKSpriteNode(imageNamed: "nextBtn")
    var label: SKLabelNode! = nil
    var tutorialVC: TutorialViewController! = nil
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        countdownView.removeFromSuperview()
        app.isStart = true
        
        guard let vc = Util.getForegroundViewController() as? TutorialViewController else {
            let tmp = Util.getForegroundViewController()
            tmp.dismiss(animated: false, completion: nil)
            return
        }
        tutorialVC = vc
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if tutorialNumber == 4 {
            forceChargeFull()
        }
    }
    
    func forceChargeFull() {
        if tutorialNumber == 4 {
            charge.isFull = true
            chargeFull()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if  !playerBall.isFire {
            playerBall.sizeChange(reverse: false)
        }
        moveTargetBall(accel: 0.0)
        
        if tutorialNumber < 3 {
            removeAllTargetBall()
        }
        judgeIsOk()
    }
    
    func judgeIsOk() {
        self.enumerateChildNodes(withName: "ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let ball = node as! SKSpriteNode
                if ball.position.y >= define.REMOVE_HEIGHT-1 {
                    if self.tutorialNumber < 3 {
                        self.tutorialVC.isOk()
                    } else if self.tutorialNumber == 4 {
                        if self.playerBall.isGold(ball) {
                                self.tutorialVC.isOk()
                        }
                    }
                }
            }
        })
    }
    
    func removeAllTargetBall() {
        self.enumerateChildNodes(withName: "t_ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let targetBall = node as! SKSpriteNode
                targetBall.removeAllActions()
                targetBall.removeFromParent()
            }
        })
    }
    
    override func collision(_ firstNode: SKNode, secondNode: SKNode, targetId: Int) {
        let num = secondNode.userData?.value(forKey: "num") as! Int
        let canRemove = (num == 1 || playerBall.isGold(firstNode))
        if !canRemove {
            return
        }
        updateComboCount(firstNode, tnode: secondNode)
        removeTargetBall(secondNode, id: targetId)
        updateScore()
        if tutorialNumber == 3 {
            self.tutorialVC.isOk()
        }
    }
    
}
