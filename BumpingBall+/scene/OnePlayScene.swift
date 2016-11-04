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
//        if self["item_ball"].count > 0 {
//            moveItemBall()
//        }
    }
    
    override func updateScore() {
        super.updateScore()
        headerView.scoreLabel.text = String(score)
    }
    
    //自陣にボールが入ったらゲームオーバーとします
    override func tballComesInTouchArea(_ node: SKSpriteNode) {
        self.isFin = true
        self.finish()
    }
    
    
    // for test..
    /*
    override func didBeginMultiPlay() {
        let itemBallCount = self["item_ball"].count
        //        combo 3, 4, 5のみ
        let canCreateItemBall = comboCount > define.COMBO_FOR_ITEM_BALL && itemBallCount < define.MAX_ITEM_BALL
        if canCreateItemBall {
            createItemBall()
        }
    }
    
    fileprivate func createItemBall() {
        itemBall = ItemBall()
        var posX: UInt! = UInt(arc4random_uniform(UInt32(CGFloat.WIDTH)))
        posX = itemBall.setInScreen(posX)
        itemBall.ball.position = CGPoint(x:CGFloat(posX), y:self.frame.height-50)
        itemBall.setCategory(targetBallCategory, targetCat: ballCategory)
        self.addChild(itemBall.ball)
        itemBall.ball.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func moveItemBall() {
        self.enumerateChildNodes(withName: "item_ball", using: {
            node, stop in
            if node is SKSpriteNode {
                let node = node as! SKSpriteNode
                guard let isCollision = node.userData?.value(forKey: "isCollision") as? Bool else {
                    return
                }
                if !isCollision {
                    self.ballUtil.setBoundX(node)
                    self.ballUtil.setBoundY(node)
                    let dx = node.userData?.value(forKey: "dx") as! CGFloat
                    let dy = node.userData?.value(forKey: "dy") as! CGFloat
                    node.position.x += dx
                    node.position.y -= dy
                }
            }
        })
    }*/
}
