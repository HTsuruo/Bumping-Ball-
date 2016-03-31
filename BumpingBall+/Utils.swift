//
//  Utils.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/01.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class Utis: NSObject {
    let WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width
    let HEIGHT: CGFloat = UIScreen.mainScreen().bounds.size.height
    let statusHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
    
    //status barのところは時刻などを見やすくするためにあけてあげる.
    func setStatusBar(parentView: UIView){
        let v:UIView = UIView(frame: CGRectMake(0,0,WIDTH,statusHeight));
        v.backgroundColor = UIColor.whiteColor()
        parentView.addSubview(v)
    }
}