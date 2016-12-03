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
    static let bigger = SKAction.playSoundFileNamed("bigger.mp3", waitForCompletion: false)
    static let launch = SKAction.playSoundFileNamed("launch.mp3", waitForCompletion: false)
    static let collisionNotRemove = SKAction.playSoundFileNamed("collision_not_remove.mp3", waitForCompletion: false)
    
//    scene以外用（ボタンクリックなど）
    static func prepareToPlay(_ data: String) -> AVAudioPlayer {
        var audioPlayer: AVAudioPlayer = AVAudioPlayer()
        var path: URL! = nil
        do {
            path = URL(fileURLWithPath: Bundle.main.path(forResource: data, ofType: "mp3")!)
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
        audioPlayer.play()
    }
}
