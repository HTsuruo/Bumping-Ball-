//
//  HeaderView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/20.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class HeaderView: UIView {

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
    
    private func loadXib() {
        NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
        contentView.frame = CGRectMake(0, 0, define.WIDTH, define.HEADER_HEIGHT)
        self.addSubview(contentView)
    }
    
    private func setHighScoreLabel() {
        let ud = NSUserDefaults.standardUserDefaults()
        let highScore = ud.integerForKey("highScore")
        highScoreLabel.text = String(highScore)
    }

}
