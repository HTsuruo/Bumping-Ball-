//
//  BallUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/24.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class BallUtil {
    
    let scaleFilepath = Bundle.main.path(forResource: "scale", ofType: "plist")
    let speedFilepath = Bundle.main.path(forResource: "speed", ofType: "plist")
    let scaleVal = DeviceUtil.getOptionalScale()
    let speedVal = DeviceUtil.getOptionalSpeed()
    let increaseVal = DeviceUtil.getIncreaseScale()
    var scaledic: NSDictionary? = nil
    var speeddic: NSDictionary? = nil
    
    
    init() {
        scaledic = NSDictionary(contentsOfFile: scaleFilepath!)
        speeddic = NSDictionary(contentsOfFile: speedFilepath!)
    }
    
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
        if posX < UInt(halfSize) {
            screenCollision = true
        }
        let sizePlusPosX = Int(posX) + halfSize
        if sizePlusPosX > Int(CGFloat.WIDTH) {
            screenCollision = true
        }
        
        if !screenCollision {
            return
        }
        
        var dx = node.userData?.value(forKey: "dx") as! Double
        dx *= -1
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
        
        var dy = node.userData?.value(forKey: "dy") as! Double
        
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
    
    func getBallImageForMix(_ playerBallId: Int, targetBall: SKNode) -> SKAction {
        var texture = SKTexture.init()
        let id = targetBall.userData?.value(forKey: "id") as! Int
        if playerBallId == BallType.blue.rawValue {
            switch BallType(rawValue: id)! as BallType {
                case .green:
                    texture = SKTexture.init(imageNamed: ballImage.GREEN)
                case .orange:
                    texture = SKTexture.init(imageNamed: ballImage.ORANGE)
                case .red:
                    texture = SKTexture.init(imageNamed: ballImage.RED)
                default:
                    break
            }
        } else {
            texture = SKTexture.init(imageNamed: ballImage.BLUE)
            targetBall.userData?.setValue(BallType.blue.rawValue, forKey: "id")
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
    
    
    func isInScaleRange(name: String, scale: Double) -> Bool {
        if let valdic: NSDictionary = scaledic?.object(forKey: name) as? NSDictionary {
            let min = (valdic.object(forKey: "min") as! Double) * Double(scaleVal)
            let max = (valdic.object(forKey: "max") as! Double) * Double(scaleVal)
            //print("\(name): {min: \(min), max: \(max)}")
            return (min <= scale && scale < max)
        }
        return false
    }
    
    func isInScaleOverMin(scale: Double) -> Bool {
        if let valdic: NSDictionary = scaledic?.object(forKey: "other") as? NSDictionary {
            let min = valdic.object(forKey: "min") as! Double * Double(scaleVal)
            return scale < min
        }
        return false
    }
    
    func isInScaleOverMax(scale: Double) -> Bool {
        if let valdic: NSDictionary = scaledic?.object(forKey: "other") as? NSDictionary {
            let max = valdic.object(forKey: "max") as! Double * Double(scaleVal)
            return max < scale
        }
        return false
    }
    
    
    func getMinScale() -> Double {
        if let valdic: NSDictionary = scaledic?.object(forKey: "other") as? NSDictionary {
            let min = (valdic.object(forKey: "min") as! Double) * Double(scaleVal)
            return min
        }
        return 0.0
    }
    
    func getMaxScale() -> Double {
        if let valdic: NSDictionary = scaledic?.object(forKey: "other") as? NSDictionary {
            let max = (valdic.object(forKey: "max") as! Double) * Double(scaleVal)
            return max
        }
        return 0.0
    }
    
    func getScale(name: String) -> CGFloat {
        if let valdic: NSDictionary = scaledic?.object(forKey: name) as? NSDictionary {
            var min = valdic.object(forKey: "min") as! CGFloat
            let max = valdic.object(forKey: "max") as! CGFloat
            let rand = Int(arc4random_uniform(2))
            var res: CGFloat = 0.0
            if rand == 0 { //min
                if min <= 0.5 { //相手ボールにしては小さいので
                    min = 0.6
                }
                res = min
            } else { //average
                res = (min + max) / 2
            }
            res = (min + max) / 2
            return res
        }
        return 1.0
    }

    func getPlayerBallSpeed(name: String) -> Double {
        if let dic: NSDictionary = speeddic?.object(forKey: name) as? NSDictionary {
            let speed = dic.object(forKey: "player") as! Double
            return speed
        }
        return 1.0
    }
    
    func getTargetBallSpeed(name: String) -> Double {
        if let dic: NSDictionary = speeddic?.object(forKey: name) as? NSDictionary {
            let speed = dic.object(forKey: "target") as! Double
            return speed * speedVal
        }
        return 1.0
    }
    
    func getIncreaseScale() -> Double {
        if let valdic: NSDictionary = scaledic?.object(forKey: "other") as? NSDictionary {
            let max = (valdic.object(forKey: "max") as! Double) * Double(scaleVal)
            let min = (valdic.object(forKey: "max") as! Double) * Double(scaleVal)
            let ave = (max + min)/2
            let res = ave / 24
            return res
        }
        return define.INCREASE_SCALE
    }
    
}
