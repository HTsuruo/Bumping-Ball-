//
//  Bgm.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/12/03.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import AVFoundation

class Bgm: NSObject {
    
    static let topMusic = "mimei"
    static let playMusic = "dancing"
    static let tutorialMusic = "tutorial"

    static var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    static var path: URL! = nil
    
    static func prepareToPlay(_ data: String) {
        do {
            self.path = URL(fileURLWithPath: Bundle.main.path(forResource: data, ofType: "caf")!)
            try self.audioPlayer = AVAudioPlayer(contentsOf: self.path, fileTypeHint: nil)
            self.audioPlayer.volume = 0.8
            self.audioPlayer.numberOfLoops = -1 //loop
            self.audioPlayer.prepareToPlay()
        } catch {
            print("cannot read sound file !!")
        }
    }
    
    static func play() {
        if !isOk() {
            return
        }
        self.audioPlayer.play()
    }
    
    static func stop() {
        if self.path == nil {
            return
        }
        self.audioPlayer.stop()
    }
    
    static func isPlaying() -> Bool {
        if !isOk() {
            return false
        }
        return self.audioPlayer.isPlaying
    }
    
    static func playBgm(filename: String) {
        let off_music = UserDefaults.standard.bool(forKey: udKey.off_music)
        if off_music {
            return
        }
        if Bgm.isPlaying() {
            Bgm.stop()
        }
        Bgm.prepareToPlay(filename)
        Bgm.play()
    }
    
    static func isOk() -> Bool {
        let off_music = UserDefaults.standard.bool(forKey: udKey.off_music)
         return !off_music && self.path != nil
    }
}
