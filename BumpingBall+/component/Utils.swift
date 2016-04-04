//
//  Utils.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

struct define {
    static let WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width
    static let HEIGHT: CGFloat = UIScreen.mainScreen().bounds.size.height
    static let statusHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
    static let MAX = 20
    static let BALL_INIT_SCALE = CGFloat(0.5)
    static let BALL_INIT_SPEED = CGFloat(0.5)
    static let TOUCH_MARGIN = CGFloat(50.0) //タッチ箇所とボールが被って見難くなってしまうので少しずらします.
    static let REMOVE_HEIGHT = CGFloat(HEIGHT - 80.0)
}

class Utils: NSObject {
    
    //status barのところは時刻などを見やすくするためにあけてあげる.
    func setStatusBar(parentView: UIView) {
        let v: UIView = UIView(frame: CGRectMake(0, 0, define.WIDTH, define.statusHeight))
        v.backgroundColor = UIColor.whiteColor()
        parentView.addSubview(v)
    }
    
}


struct colorUtils {
    static let blue = colorWithHexString("2196F3")
    static let green = colorWithHexString("4CAF50")
    static let orange = colorWithHexString("FF9800")
    static let red = colorWithHexString("f44336")
    
}

//rgb指定ではなくカラーコードで指定できるようにした.
func colorWithHexString (hex: String) -> UIColor {
    
    let cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString as String).characters.count != 6 {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringWithRange(NSRange(location: 0, length: 2))
    let gString = (cString as NSString).substringWithRange(NSRange(location: 2, length: 2))
    let bString = (cString as NSString).substringWithRange(NSRange(location: 4, length: 2))
    
    var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    return UIColor(
        red: CGFloat(Float(r) / 255.0),
        green: CGFloat(Float(g) / 255.0),
        blue: CGFloat(Float(b) / 255.0),
        alpha: CGFloat(Float(1.0))
    )
}
