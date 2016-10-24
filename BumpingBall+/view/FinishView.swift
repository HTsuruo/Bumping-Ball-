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

class FinishView: UIView {
    
    @IBOutlet var finishView: UIView!
    @IBOutlet weak var toTopBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var lineBtn: UIButton!
    @IBOutlet weak var againBtn: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var vc: UIViewController!
    var scenevc: SceneViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("FinishView", owner: self, options: nil)
        finishView.frame = frame
        self.addSubview(finishView)
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
        }
        GameCenterUtil.sendScore(totalScore, leaderBoardId: difficultyStr)
    }
    
    func setup() {
        vc = Util.getForegroundViewController()
        scenevc = vc as! SceneViewController
    }
    
    @IBAction func onClickToTopBtn(_ sender: UIButton) {
        vc.dismiss(animated: true, completion: nil)
        scenevc.skView.isPaused = true
    }
    
    @IBAction func onClickAgainBtn(_ sender: UIButton) {
        scenevc.skView.isPaused = true
        vc.loadView()
        vc.viewDidLoad()
    }
    
    @IBAction func onClickTwitterBtn(_ sender: UIButton) {
        let text = "【Bumping Ball+】"
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        composeViewController.setInitialText(text)
        vc.present(composeViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickFacebookBtn(_ sender: UIButton) {
        let text = "【Bumping Ball+】"
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        composeViewController.setInitialText(text)
        vc.present(composeViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickLineBtn(_ sender: UIButton) {
        let text: String! = "【Bumping Ball+】"
        let encodeMessage: String! = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let messageURL: URL! = URL( string: "line://msg/text/" + encodeMessage )
        if UIApplication.shared.canOpenURL(messageURL) {
            UIApplication.shared.openURL( messageURL )
        }
    }
}
