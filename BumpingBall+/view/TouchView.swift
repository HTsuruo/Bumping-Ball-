//
//  TouchView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/21.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class TouchView: SKSpriteNode {
    
    let animation = Animation()
    let touchViewTxt = TouchViewTxt()
    
    init() {
        let tx = SKTexture(imageNamed: "touchView")
        super.init(texture: tx, color: UIColor.clear, size: CGSize(width: CGFloat.WIDTH, height: define.TOUCH_HEIGHT))
        self.position = CGPoint(x: CGFloat.WIDTH/2, y: define.TOUCH_HEIGHT/2)
        self.alpha = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func chargeFull() {
        let action = animation.chargeMeterAnimation(0.5)
        self.run(action)
    }
}
