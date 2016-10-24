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

struct colorUtil {
    static let blue = UIColor.hex(hexStr: "2196F3", alpha: 1.0)
    static let green = UIColor.hex(hexStr: "4CAF50", alpha: 1.0)
    static let orange = UIColor.hex(hexStr: "FF9800", alpha: 1.0)
    static let red = UIColor.hex(hexStr: "f44336", alpha: 1.0)
    static let gold = UIColor.hex(hexStr: "ffd700", alpha: 1.0)
    static let navy = UIColor.hex(hexStr: "101B38", alpha: 1.0)
    static let black = UIColor.hex(hexStr: "1D1D1D", alpha: 1.0)
    static let lifered = UIColor.hex(hexStr: "EC5D57", alpha: 1.0)
    static let lifeblue = UIColor.hex(hexStr: "51A7F9", alpha: 1.0)
    static let selected = UIColor.hex(hexStr: "eeeeee", alpha: 0.3)
    static let loseColor = UIColor.hex(hexStr: "0365C0", alpha: 1.0)
    static let winColor = UIColor.hex(hexStr: "C82506", alpha: 1.0)
}
