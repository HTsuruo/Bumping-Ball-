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
    
    static var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    static var path: NSURL = NSURL()
    
    static func prepareToPlay(data: String) {
        do {
            self.path = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(data, ofType: "mp3")!)
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: self.path, fileTypeHint: nil)
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
