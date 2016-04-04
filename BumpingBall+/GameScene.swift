//
//  GameScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright (c) 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    
    var ball = Ball()
    let util = Utils()
    let ballUtil = BallUtils()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
       
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "score"
        myLabel.fontSize = 30
        myLabel.fontColor = UIColor.whiteColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-30)
        self.addChild(myLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            ball = Ball()
            ball.ball.name = "ball"
            ball.ball.position.x = location.x
            ball.ball.position.y = location.y + define.TOUCH_MARGIN
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            ball.ball.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(ball.ball)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touche in touches {
            let location = touche.locationInNode(self)
            ball.ball.position.x = location.x
            ball.ball.position.y = location.y + define.TOUCH_MARGIN
         }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        ball.ball.runAction(Sound.launch)
        ball.isFire = true
        let actionMove = SKAction.moveToY(util.HEIGHT, duration: Double(ball.ballSpeed))
        ball.ball.runAction(actionMove)
    }
   
    override func update(currentTime: CFTimeInterval) {
        removeBall()
        if  !ball.isFire {
            sizeChange()
        }
        
    }
    
    private func removeBall() {
        self.enumerateChildNodesWithName("ball", usingBlock: {
            node, step in
            if node is SKSpriteNode {
                let targetBall = node as! SKSpriteNode
                if targetBall.position.y >= self.util.HEIGHT {
                    targetBall.runAction(SKAction.fadeOutWithDuration(0.3), completion: {
                        targetBall.removeFromParent()
                    })
                }
            }
        })
    }
    
    private func sizeChange() {
//        let actionScale = SKAction.scaleTo(1.0, duration: 0.5)
        ball.ballScale += 0.015
        if ball.ballScale < 0.7 {
            ball.ballSpeed = define.BALL_INIT_SPEED
            ball.ball.runAction(ballUtil.setBlue())
        } else if ball.ballScale < 0.9 {
            ball.ballSpeed = 0.75
            ball.ball.runAction(ballUtil.setGreen())
        } else if ball.ballScale < 1.1 {
            ball.ballSpeed = 1.0
            ball.ball.runAction(ballUtil.setOrange())
        } else if ball.ballScale < 1.3 {
            ball.ballSpeed = 1.25
            ball.ball.runAction(ballUtil.setRed())
        } else {
            ball.ballScale = define.BALL_INIT_SCALE
            ball.ballSpeed = define.BALL_INIT_SPEED
        }
        ball.ball.setScale(ball.ballScale)
    }
    
}
