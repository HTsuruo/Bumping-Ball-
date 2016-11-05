//
//  BallUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/24.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class BallUtil: NSObject {
    
    func setBlue() -> SKAction {
        let blue = SKTexture.init(imageNamed: ballImage.BLUE)
        return SKAction.setTexture(blue, resize: true)
    }
    
    func setGreen() -> SKAction {
        let green = SKTexture.init(imageNamed: ballImage.GREEN)
        return SKAction.setTexture(green, resize: true)
    }
    
    func setOrange() -> SKAction {
        let orange = SKTexture.init(imageNamed: ballImage.ORANGE)
        return SKAction.setTexture(orange, resize: true)
    }
    
    func setRed() -> SKAction {
        let red = SKTexture.init(imageNamed: ballImage.RED)
        return SKAction.setTexture(red, resize: true)
    }
    
    func setGold() -> SKAction {
        let gold = SKTexture.init(imageNamed: ballImage.GOLD)
        return SKAction.setTexture(gold, resize: true)
    }
    
    //   横方向の跳ね返り処理
    func setBoundX(_ node: SKSpriteNode) {
        let halfSize = Int(node.size.width/2)
        var screenCollision = false
        
        if node.position.x < CGFloat(halfSize) {
            node.position.x = CGFloat(halfSize)
            screenCollision = true
        }
        
        if node.position.x > CGFloat.WIDTH - CGFloat(halfSize) {
            node.position.x = CGFloat.WIDTH - CGFloat(halfSize)
            screenCollision = true
        }
        
        let posX: UInt = UInt(node.position.x)
        var dx = node.userData?.value(forKey: "dx") as! CGFloat
        
        if posX < UInt(halfSize) {
            screenCollision = true
        }
        let sizePlusPosX = Int(posX) + halfSize
        if sizePlusPosX > Int(CGFloat.WIDTH) {
            screenCollision = true
        }
        
        if screenCollision {
            dx *= -1
        }
        node.userData?.setValue(dx, forKey: "dx")
    }
    
    //   縦方向の跳ね返り処理
    func setBoundY(_ node: SKSpriteNode) {
        let halfSize = Int(node.size.width/2)
        var screenCollision = false
        
        if node.position.y > CGFloat.HEIGHT - (define.HEADER_HEIGHT + CGFloat.STATUS_HEIGHT + CGFloat(halfSize)) {
            node.position.y = CGFloat.HEIGHT - (define.HEADER_HEIGHT + CGFloat.STATUS_HEIGHT + CGFloat(halfSize))
            screenCollision = true
        }
        
        if node.position.y < CGFloat.HEIGHT * 3/5 - CGFloat(halfSize) {
            node.position.y = CGFloat.HEIGHT * 3/5 - CGFloat(halfSize)
            screenCollision = true
        }
        
        var dy = node.userData?.value(forKey: "dy") as! CGFloat
        
        if screenCollision {
            dy *= -1
        }
        node.userData?.setValue(dy, forKey: "dy")
    }
    
    func getScoreByCombo(_ comboCount: Int) -> Int {
        switch comboCount {
        case 1:
            return 100
        case 2:
            return 200
        case 3:
            return 300
        case 4:
            return 400
        case 5:
            return 700
        case 6:
            return 1000
        default:
            return 0
        }
    }
    
    func getBallImageByNum(_ id: Int, num: Int) -> SKAction {
        var texture = SKTexture.init()
        switch id {
        case BallType.blue.rawValue:
            texture = SKTexture.init(imageNamed: getBlueBallImageByNum(num))
            break
        case BallType.green.rawValue:
            texture = SKTexture.init(imageNamed: getGreenBallImageByNum(num))
            break
        case BallType.orange.rawValue:
            texture = SKTexture.init(imageNamed: getOrangeBallImageByNum(num))
            break
        case BallType.red.rawValue:
            texture = SKTexture.init(imageNamed: getRedBallImageByNum(num))
            break
        default:
            break
        }
        return SKAction.setTexture(texture, resize: false)
    }
    
    func getBlueBallImageByNum(_ num: Int) -> String {
        return "ball_blue_"+String(num)
    }
    
    func getGreenBallImageByNum(_ num: Int) -> String {
        return "ball_green_"+String(num)
    }
    
    func getOrangeBallImageByNum(_ num: Int) -> String {
        return "ball_orange_"+String(num)
    }
    
    func getRedBallImageByNum(_ num: Int) -> String {
        return "ball_red_"+String(num)
    }
    
}
