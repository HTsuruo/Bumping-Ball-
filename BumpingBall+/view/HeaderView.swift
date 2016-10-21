//
//  HeaderView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/20.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setHighScoreLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadXib() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: define.WIDTH, height: define.HEADER_HEIGHT)
        self.addSubview(contentView)
    }
    
    fileprivate func setHighScoreLabel() {
        let ud = UserDefaults.standard
        let highScore = ud.integer(forKey: "highscore-"+app.selectedDiffculty.getString())
        highScoreLabel.text = String(highScore)
    }

}
