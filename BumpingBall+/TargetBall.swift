//
//  TargetBall.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/04.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

struct TargetBall {
    var ball = SKSpriteNode(imageNamed: ballImage.BLUE)
    var ballScale = define.BALL_INIT_SCALE
    var ballSpeed = define.BALL_INIT_SPEED
}
