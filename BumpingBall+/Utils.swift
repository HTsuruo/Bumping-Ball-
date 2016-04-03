//
//  Utils.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

struct define {
    static let MAX = 20
    static let BALL_INIT_SCALE = CGFloat(0.5)
    static let BALL_INIT_SPEED = CGFloat(0.5)
    static let TOUCH_MARGIN = CGFloat(50.0) //タッチ箇所とボールが被って見難くなってしまうので少しずらします.
}

class Utils: NSObject {
    let WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width
    let HEIGHT: CGFloat = UIScreen.mainScreen().bounds.size.height
    let statusHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
    
    //status barのところは時刻などを見やすくするためにあけてあげる.
    func setStatusBar(parentView: UIView) {
        let v: UIView = UIView(frame: CGRectMake(0, 0, WIDTH, statusHeight))
        v.backgroundColor = UIColor.whiteColor()
        parentView.addSubview(v)
    }
    
}
