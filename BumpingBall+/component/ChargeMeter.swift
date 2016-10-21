//
//  ChargeMeter.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/20.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class ChargeMeter: SKSpriteNode {

    var initialPos = -(CGFloat.WIDTH/2 + 15)
    static let CHARGE_MAX = 50
    var charge = 0
    var isFull = false
    let animation = Animation()
    
    init() {
        let texture = SKTexture(imageNamed: "chargeMeter")
        super.init(texture: texture, color: colorUtils.gold, size: CGSize(width: CGFloat.WIDTH + 30, height: 5))
        self.position = CGPoint(x: initialPos, y: CGFloat.HEIGHT - (define.HEADER_HEIGHT + 2.5))
        let action = animation.chargeMeterAnimation(0.8)
        self.run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ combo: Int) {
        charge += combo
        if isFull {
            return
        }
        if charge >= 50 {
            isFull = true
        }
        let currentPos = self.position.x
        let nextPos = currentPos + getIncrement(combo)
        let move = SKAction.moveTo(x: CGFloat(nextPos), duration: 0.4)
        self.run(move)
    }
    
    func getIncrement(_ combo: Int) -> CGFloat {
        return CGFloat(combo) * (CGFloat.WIDTH / 50)
    }
    
    func reset () {
        charge = 0
        isFull = false
        self.position = CGPoint(x: initialPos, y: CGFloat.HEIGHT - (define.HEADER_HEIGHT + 2.5))
    }


}
