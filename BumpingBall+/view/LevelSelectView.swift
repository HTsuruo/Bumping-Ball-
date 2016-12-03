//
//  LevelSelectView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/07.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import Spring

class LevelSelectView: UIView {

    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var contentView: SpringButton!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var normalBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib(frame: frame)
        easyBtn.isHidden = false
        normalBtn.isHidden = false
        hardBtn.isHidden = false
//        contentView.layer.borderColor = UIColor.white.cgColor
//        contentView.layer.borderWidth = 2
//        contentView.layer.cornerRadius = 30
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadXib(frame: CGRect) {
        Bundle.main.loadNibNamed("LevelSelectView", owner: self, options: nil)
//        contentView.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
        contentView.frame = frame
        self.addSubview(contentView)
    }

    @IBAction func onClickEasyBtn(_ sender: UIButton) {
        app.selectedDiffculty = DifficultyType.easy
        app.level = 1
        transitionToPlay()
        normalBtn.isHidden = true
        hardBtn.isHidden = true
    }
    
    @IBAction func onClickNormalBtn(_ sender: UIButton) {
        app.selectedDiffculty = DifficultyType.normal
        app.level = 1
        transitionToPlay()
        easyBtn.isHidden = true
        hardBtn.isHidden = true
    }
    
    @IBAction func onClickHardBtn(_ sender: UIButton) {
        app.selectedDiffculty = DifficultyType.hard
        app.level = 5
        transitionToPlay()
        easyBtn.isHidden = true
        normalBtn.isHidden = true
    }
    
    func transitionToPlay() {
        let vc = Util.getForegroundViewController()
        vc.performSegue(withIdentifier: "toPlay", sender: self)
    }
    
}
