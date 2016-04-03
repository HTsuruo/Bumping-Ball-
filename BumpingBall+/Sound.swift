//
//  Sound.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/04.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

class Sound: NSObject {
    static let bigger = SKAction.playSoundFileNamed("bigger.mp3", waitForCompletion: false)
    static let launch = SKAction.playSoundFileNamed("launch.mp3", waitForCompletion: false)
}
