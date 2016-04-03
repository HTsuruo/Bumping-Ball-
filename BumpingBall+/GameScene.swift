//
//  GameScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright (c) 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var ball = Ball()
    let util = Utils()
    let ballUtil = BallUtils()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.whiteColor()
       
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "score"
        myLabel.fontSize = 30
        myLabel.fontColor = UIColor.blackColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-30)
        self.addChild(myLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            ball = Ball()
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
        ball.isFire = true
//        ball.ball.runAction(actionMove)
//        print("id : ", ball.ballId, ", num : ", num)
        let actionMove = SKAction.moveToY(util.HEIGHT, duration: Double(ball.ballSpeed))
        ball.ball.runAction(actionMove, completion: {
            self.ball.ball.removeFromParent()
        })
    }
   
    override func update(currentTime: CFTimeInterval) {
        if  !ball.isFire {
            sizeChange()
        }
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
