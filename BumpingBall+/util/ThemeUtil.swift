//
//  ThemeUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/12/17.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class ThemeUtil {
    
    let SNOW = "snow"
    let SPACE = "space"
    
    let animation = Animation()
    
    init() {
        
    }
    
    func getTheme() -> String {
        let count = ThemeType.count
        let rand = Int(arc4random_uniform(UInt32(count)))
        let themeType = ThemeType(rawValue: rand)! as ThemeType
        var theme = ""
        switch themeType {
        case .space:
            theme = "space"
            break
        case .snow:
            theme = "snow"
            break
        default:
            theme = "space"
            break
        }
        return theme
    }
    
    func getBackground(theme: String) -> SKSpriteNode {
        let background = SKSpriteNode(imageNamed: "background_\(theme)")
        background.size = CGSize(width: CGFloat.WIDTH, height: CGFloat.HEIGHT * 2)
        background.position = CGFloat.CENTER
        background.alpha = 0.3
        
        let movetoY = SKAction.moveTo(y: 0.0, duration: 15.0)
        let backToY = SKAction.moveTo(y: CGFloat.HEIGHT, duration: 0.0)
        let sequence = SKAction.sequence([movetoY, backToY])
        let forever = SKAction.repeatForever(sequence)
        background.run(forever)
        
        return background
    }
    
    func getBackgroundAnimation(theme: String) -> SKEmitterNode {
        return animation.backgroundAnimation(theme: theme)
    }
}
