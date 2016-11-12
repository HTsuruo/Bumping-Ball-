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
    static let collision = SKAction.playSoundFileNamed("collision.mp3", waitForCompletion: false)
    
    static let topMusic = SKAction.playSoundFileNamed("texture.mp3", waitForCompletion: false)
    static let eternal = SKAction.playSoundFileNamed("eternal_galaxy.mp3", waitForCompletion: false)
    
    static var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    static var path: URL! = nil
    
    static func prepareToPlay(_ data: String) {
        do {
            self.path = URL(fileURLWithPath: Bundle.main.path(forResource: data, ofType: "mp3")!)
            try self.audioPlayer = AVAudioPlayer(contentsOf: self.path, fileTypeHint: nil)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.volume = 0.8
        } catch {
            print("cannot read sound file !!")
        }
    }
    static func play() {
        self.audioPlayer.play()
    }
}
