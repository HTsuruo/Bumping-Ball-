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
//    scene用
    static let bigger = SKAction.playSoundFileNamed("bigger.caf", waitForCompletion: false)
    static let launch = SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false)
    static let collisionNotRemove = SKAction.playSoundFileNamed("collision_not_remove.caf", waitForCompletion: false)
    static let collision = SKAction.playSoundFileNamed("collision.caf", waitForCompletion: false)
    static let collision_perfect = SKAction.playSoundFileNamed("collision_perfect.caf", waitForCompletion: false)
    static let gameover = SKAction.playSoundFileNamed("gameover.caf", waitForCompletion: false)
    
//    scene以外用（ボタンクリックなど）
    static let button = "button"
    static let buttonError = "button_error"
    static let buttonLevelSelect = "button_level_select"
    static let countdown = "countdown"
    static let countdownGo = "countdown_go"
    static let pause = "pause"
    
    static func prepareToPlay(_ data: String) -> AVAudioPlayer {
        var audioPlayer: AVAudioPlayer = AVAudioPlayer()
        var path: URL! = nil
        do {
            path = URL(fileURLWithPath: Bundle.main.path(forResource: data, ofType: "caf")!)
            try audioPlayer = AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
            audioPlayer.volume = 1.0
            audioPlayer.prepareToPlay()
            return audioPlayer
        } catch {
            print("cannot read sound file !!")
        }
        return audioPlayer
    }
    
    static func play(audioPlayer: AVAudioPlayer) {
        if UserDefaults.standard.bool(forKey: udKey.off_sound) {
            return
        }
        audioPlayer.play()
    }
    
    static func play(node: SKNode, action: SKAction) {
        if UserDefaults.standard.bool(forKey: udKey.off_sound) {
            return
        }
        node.run(action)
    }
}
