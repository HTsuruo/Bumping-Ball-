//
//  Utils.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

struct define {
    static let MAX = 20
    static let BALL_INIT_SCALE = CGFloat(0.5)
    static let BALL_INIT_SPEED = CGFloat(0.5)
    static let TOUCH_MARGIN = CGFloat(50.0) //タッチ箇所とボールが被って見難くなってしまうので少しずらします.
    static let HEADER_HEIGHT: CGFloat = 60.0
    static let REMOVE_HEIGHT = CGFloat(CGFloat.HEIGHT - (HEADER_HEIGHT))
    static let TOUCH_HEIGHT: CGFloat = 65.0
    static let TOUCH_AREA = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: TOUCH_HEIGHT)
}

struct Util {
    
    //最前面のビューコントローラを取得する
   static func getForegroundViewController() -> UIViewController {
        var tc = UIApplication.shared.keyWindow?.rootViewController
        while tc!.presentedViewController != nil {
            tc = tc!.presentedViewController
        }
        return tc!
    }
}

class BallUtils: NSObject {
    
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
    
    //   跳ね返り処理
    func setRebound(_ node: SKSpriteNode) {
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
    
}

struct colorUtils {
    static let blue = UIColor.hex(hexStr: "2196F3", alpha: 1.0)
    static let green = UIColor.hex(hexStr: "4CAF50", alpha: 1.0)
    static let orange = UIColor.hex(hexStr: "FF9800", alpha: 1.0)
    static let red = UIColor.hex(hexStr: "f44336", alpha: 1.0)
    static let gold = UIColor.hex(hexStr: "ffd700", alpha: 1.0)
    static let navy = UIColor.hex(hexStr: "101B38", alpha: 1.0)
    static let black = UIColor.hex(hexStr: "1D1D1D", alpha: 1.0)
    static let lifered = UIColor.hex(hexStr: "EC5D57", alpha: 1.0)
    static let lifeblue = UIColor.hex(hexStr: "51A7F9", alpha: 1.0)
    static let clear = UIColor.clear
    static let selected = UIColor.hex(hexStr: "eeeeee", alpha: 0.3)
}
