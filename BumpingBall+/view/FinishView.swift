//
//  FinishView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/04/18.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit
import Social
import Spring
import GoogleMobileAds

class FinishView: UIView {
    
    @IBOutlet var finishView: UIView!
    @IBOutlet weak var toTopBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var lineBtn: UIButton!
    @IBOutlet weak var againBtn: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var highScoreStamp: SpringImageView!
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var vc: UIViewController!
    var scenevc: SceneViewController!
    let btnSound = Sound.prepareToPlay("button")
    var totalScore = 0
    let adUtil = AdUitl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("FinishView", owner: self, options: nil)
        finishView.frame = frame
        self.addSubview(finishView)
        highScoreStamp.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScoreLabel(_ totalScore: Int) {
        mainLabel.text = String(totalScore)
        let ud = UserDefaults.standard
        let difficultyStr = app.selectedDiffculty.getString()
        let highScore = ud.integer(forKey: "highscore-"+difficultyStr)
        if totalScore > highScore {
            ud.set(totalScore, forKey: "highscore-"+difficultyStr)
            if app.selectedPlay == .one {
                highScoreStamp.isHidden = false
            }
        }
        self.totalScore = totalScore
        GameCenterUtil.sendScore(totalScore, leaderBoardId: difficultyStr)
    }
    
    func setLevelLabel() {
        levelLabel.textColor = UIColor.gray
        if app.selectedPlay == .one {
            levelLabel.text = "LEVEL \(app.level)"
            return
        }
        if app.selectedPlay == .bluetooth {
            let ud = UserDefaults.standard
            levelLabel.text = "win: \(ud.integer(forKey: udKey.bluetooth_win_count))\nlose: \(ud.integer(forKey: udKey.bluetooth_lose_count))"
            return
        }
        levelLabel.isHidden = true
    }
    
    func setup() {
        vc = Util.getForegroundViewController()
        scenevc = vc as! SceneViewController
        adUtil.showBanner(vc: vc, view: self, banner: kGADAdSizeBanner, isBottom: true)
    }
    
    @IBAction func onClickToTopBtn(_ sender: UIButton) {
        btnSound.play()
        vc.dismiss(animated: true, completion: nil)
        scenevc.skView.isPaused = true
        if app.bluetoothSession != nil {
            app.bluetoothSession?.disconnect()
        }
    }
    
    @IBAction func onClickAgainBtn(_ sender: UIButton) {
        btnSound.play()
        scenevc.skView.isPaused = true
        vc.loadView()
        vc.viewDidLoad()
    }
    
    @IBAction func onClickTwitterBtn(_ sender: UIButton) {
        btnSound.play()
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        composeViewController.setInitialText(getSnsMsg())
        vc.present(composeViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickFacebookBtn(_ sender: UIButton) {
        btnSound.play()
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        composeViewController.setInitialText(getSnsMsg())
        vc.present(composeViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickLineBtn(_ sender: UIButton) {
        btnSound.play()
        let encodeMessage: String! = getSnsMsg().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let messageURL: URL! = URL( string: "line://msg/text/" + encodeMessage )
        if UIApplication.shared.canOpenURL(messageURL) {
            UIApplication.shared.openURL( messageURL )
        }
    }
    
    func getSnsMsg() -> String {
        var msg = ""
        if app.selectedPlay == .one {
            let difficulty = app.selectedDiffculty.getLocalizedString()
            msg = String(format: NSLocalizedString("sns_message_with_score", comment: ""), self.totalScore, difficulty) + "\n"
        }
        let text = "【Bumping Ball+】\n\(msg)\(define.APPSTORE_URL)"
        return text
    }
}
