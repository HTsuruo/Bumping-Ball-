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

    var initialPos = -(define.WIDTH/2 + 10)
    static let CHARGE_MAX = 50
    var charge = 0
    var isFull = false
    
    init() {
        let texture = SKTexture(imageNamed: "chargeMeter")
        super.init(texture: texture, color: colorUtils.gold, size: CGSizeMake(define.WIDTH + 20, 5))
        self.position = CGPointMake(initialPos, define.HEIGHT - (define.HEADER_HEIGHT + 2.5))
        changeColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(combo: Int) {
        charge += combo
        print(charge)
        if isFull {
            return
        }
        if charge >= 50 {
            isFull = true
        }
        let currentPos = self.position.x
        let nextPos = currentPos + getIncrement(combo)
        let move = SKAction.moveToX(CGFloat(nextPos), duration: 0.4)
        self.runAction(move)
    }
    
    func getIncrement(combo: Int) -> CGFloat {
        return CGFloat(combo) * (define.WIDTH / 50)
    }
    
    func changeColor() {
        let gold = SKAction.colorizeWithColor(colorUtils.gold, colorBlendFactor: 1.0, duration: 0.8)
        let orange = SKAction.colorizeWithColor(colorUtils.orange, colorBlendFactor: 1.0, duration: 0.8)
        let sequence  = SKAction.sequence([gold, orange])
        let foreverChange  = SKAction.repeatActionForever(sequence)
        self.runAction(foreverChange)
    }
    
    func reset () {
        charge = 0
        isFull = false
        self.position = CGPointMake(initialPos, define.HEIGHT - (define.HEADER_HEIGHT + 2.5))
    }


}
