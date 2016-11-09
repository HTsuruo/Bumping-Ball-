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
        
//        label = SKLabelNode(text: tutorialTxt[tutorialNumber])
//        label.fontSize = 22
//        label.position = CGPoint(x: CGFloat.CENTER.x, y: CGFloat.HEIGHT * 0.7)
//        self.addChild(label)
//        
//        nextButton = SKSpriteNode(imageNamed: "nextBtn")
//        nextButton.position = CGPoint(x: CGFloat.CENTER.x, y: CGFloat.CENTER.y - CGFloat(80))
//        nextButton.zPosition = 1
//        nextButton.name = "next"
//        nextButton.xScale = 0.8
//        nextButton.yScale = 0.8
//        self.addChild(nextButton)
    }
    
    override func willMove(from view: SKView) {
        guard let vc = Util.getForegroundViewController() as? TutorialViewController else {
            let tmp = Util.getForegroundViewController()
            tmp.dismiss(animated: false, completion: nil)
            return
        }
        tutorialVC = vc
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "next" {
                print("button tapped")
                tutorialNumber += 1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if  !playerBall.isFire {
            playerBall.sizeChange(reverse: false)
        }
        moveTargetBall(accel: 0.0)
        
        if tutorialNumber < 2 {
            removeAllTargetBall()
        }
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
        if canRemove {
            updateComboCount(firstNode, tnode: secondNode)
            removeTargetBall(secondNode, id: targetId)
            updateScore()
        } else {
            changeTargetBall(firstNode, tBall: secondNode, id: targetId)
        }
    }
    
}
