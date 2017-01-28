//
//  OnePlayScene.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class OnePlayScene: BaseScene {
    
    let headerView = HeaderView()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        playSceneBgm()
        self.view?.addSubview(headerView)
        print("difficulty: \(app.selectedDiffculty)")
        startCountdown()
    }
    
    func startCountdown() {
        //切り替えのタイミング上delayをはさみます.
        let delay = SKAction.wait(forDuration: 0.5)
        let run = SKAction.run({
            self.countdownView.start()
        })
        self.run(SKAction.sequence([delay, run]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if  !playerBall.isFire {
            playerBall.sizeChange(reverse: false)
        }
        moveTargetBall(accel: 0.0)
    }
    
    override func updateScore() {
        super.updateScore()
        headerView.scoreLabel.text = String(score)
    }
    
    //自陣にボールが入ったらゲームオーバーとします
    override func tballComesInTouchArea(_ node: SKSpriteNode) {
        super.tballComesInTouchArea(node)
        self.isFin = true
        Sound.play(node: self, action: Sound.gameover)
        self.finish()
        enableHardMode()
        enableImpossibleMode()
    }
    
    
    override func collision(_ firstNode: SKNode, secondNode: SKNode, targetId: Int) {
        let num = secondNode.userData?.value(forKey: "num") as! Int
        let canRemove = (num == 1 || playerBall.isGold(firstNode))
        if canRemove {
            updateComboCount(firstNode, tnode: secondNode)
            removeTargetBall(secondNode, id: targetId)
            updateScore()
        } else {
            Sound.play(node: self, action: Sound.collisionNotRemove)
            changeTargetBall(firstNode, tBall: secondNode, id: targetId)
        }
    }
    
    func enableHardMode() {
        if app.selectedDiffculty != .normal {
            return
        }
        if UserDefaults.standard.bool(forKey: udKey.hard_mode_on) {
            return
        }
        if app.level < define.REQUIRED_LEVEL_HARD {
            return
        }
        UserDefaults.standard.set(true, forKey: udKey.hard_mode_on)
        let alert = AlertUtil()
        let difficulty = DifficultyType.hard.getLocalizedString()
        let msg = String(format: NSLocalizedString("enable_play_new_mode", comment: ""), difficulty)
        alert.custom(title: NSLocalizedString("info", comment: ""), msg: msg)
    }
    
    func enableImpossibleMode() {
        if app.selectedDiffculty != .hard {
            return
        }
        if UserDefaults.standard.bool(forKey: udKey.impossible_mode_on) {
            return
        }
        if app.level < define.REQUIRED_LEVEL_IMPOSSIBLE {
            return
        }
        UserDefaults.standard.set(true, forKey: udKey.impossible_mode_on)
        let alert = AlertUtil()
        let difficulty = DifficultyType.impossible.getLocalizedString()
        let msg = String(format: NSLocalizedString("enable_play_new_mode", comment: ""), difficulty)
        alert.custom(title: NSLocalizedString("info", comment: ""), msg: msg)
    }
}
