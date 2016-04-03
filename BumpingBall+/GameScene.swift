//
//  GameScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright (c) 平成28年 Hideki Tsuruoka. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var ballScale = CGFloat(0.2)
    var ball: [Ball] = []
    var num = 0
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.whiteColor()
        
        for var i=0; i<define.MAX; i++ {
            ball.append(Ball())
            ball[i].ballId = num
            ball[i].ball = SKSpriteNode(imageNamed: ballImage.BLUE)
            ball[i].ball.setScale(ballScale)
        }
       
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            print("num : ", num)
            let location = touch.locationInNode(self)
            
            /*ball.append(Ball())
            ball[num].ballId = num
            ball[num].ball = SKSpriteNode(imageNamed: "ball_blue")
            ball[num].ball.xScale = 0.3
            ball[num].ball.yScale = 0.3*/
            ball[num].ball.position = location
            ball[num].isTouch = true
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            ball[num].ball.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(ball[num].ball)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touche in touches {
            let location = touche.locationInNode(self)
            ball[num].ball.position = location
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        ball[num].isFire = true
        ball[num].isTouch = false
        
        if num < define.MAX-2 {
            num++
        } else {
            num = 0
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if ball[num].isTouch {
            sizeChange(num)
        }
        
        for var i=0; i<define.MAX; i++ {
            if  ball[i].isFire {
                move(i)
            }
        }
    }
    
    private func sizeChange(target: Int) {
        ball[target].ballScale += 0.01
        if ball[target].ballScale > 0.8 {
            ball[target].ballScale = 0.3
        }
        ball[target].ball.setScale(ball[target].ballScale)
    }
    
    private func move(target: Int) {
        ball[target].ball.position.y += 10
    }
    
}
