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
    @IBOutlet weak var totalScoreLabel: UILabel!
    let util = Utils()
    var app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("FinishView", owner: self, options: nil)
        finishView.frame = frame
        self.addSubview(finishView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScoreLabel(totalScore: Int) {
        totalScoreLabel.text = String(totalScore)
        let ud = NSUserDefaults.standardUserDefaults()
        let difficultyStr = app.selectedDiffculty.getString()
        let highScore = ud.integerForKey("highscore-"+difficultyStr)
        if totalScore > highScore {
            ud.setInteger(totalScore, forKey: "highscore-"+difficultyStr)
        }
        GameCenterUtil.sendScore(totalScore, leaderBoardId: difficultyStr)
    }
    
    @IBAction func onClickToTopBtn(sender: UIButton) {
        let onePlayVC = util.getForegroundViewController()
        onePlayVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onClickAgainBtn(sender: UIButton) {
        let foregroundVC = util.getForegroundViewController()
        foregroundVC.loadView()
        foregroundVC.viewDidLoad()
    }
    
    @IBAction func onClickTwitterBtn(sender: UIButton) {
        let text = "【Bumping Ball+】"
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        composeViewController.setInitialText(text)
        let foregroundVC = util.getForegroundViewController()
        foregroundVC.presentViewController(composeViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickFacebookBtn(sender: UIButton) {
        let text = "【Bumping Ball+】"
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        composeViewController.setInitialText(text)
        let foregroundVC = util.getForegroundViewController()
        foregroundVC.presentViewController(composeViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickLineBtn(sender: UIButton) {
        let text: String! = "【Bumping Ball+】"
        let encodeMessage: String! = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let messageURL: NSURL! = NSURL( string: "line://msg/text/" + encodeMessage )
        if UIApplication.sharedApplication().canOpenURL(messageURL) {
            UIApplication.sharedApplication().openURL( messageURL )
        }
    }
}
