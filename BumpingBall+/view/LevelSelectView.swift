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
    @IBOutlet var easyBtn: SpringButton!
    @IBOutlet var normalBtn: SpringButton!
    @IBOutlet var hardBtn: SpringButton!
    @IBOutlet var impossibleBtn: SpringButton!
    let btnSelectSound = Sound.prepareToPlay(Sound.buttonLevelSelect)
    let btnErorrSound = Sound.prepareToPlay(Sound.buttonError)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib(frame: frame)
        easyBtn.isHidden = false
        normalBtn.isHidden = false
        hardBtn.isHidden = false
        impossibleBtn.isHidden = false
        
        setExistUserData()
        
        if !UserDefaults.standard.bool(forKey: udKey.hard_mode_on) {
            let image = UIImage(named: "hardBtnOff")
            hardBtn.setImage(image, for: .normal)
        }
        
        if !UserDefaults.standard.bool(forKey: udKey.impossible_mode_on) {
            let image = UIImage(named: "impossibleBtnOff")
            impossibleBtn.setImage(image, for: .normal)
        }
        
//        contentView.layer.borderColor = UIColor.white.cgColor
//        contentView.layer.borderWidth = 2
//        contentView.layer.cornerRadius = 30
    }
    
//    既存のユーザデータをセットします.
    func setExistUserData() {
//        udの名前が不適切であったため変換します.
        if UserDefaults.standard.bool(forKey: "true") {
            UserDefaults.standard.set(true, forKey: udKey.hard_mode_on)
        }
    }
    
    func startAnimation() {
        easyBtn.animate()
        normalBtn.animate()
        hardBtn.animate()
        impossibleBtn.animate()
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
        Sound.play(audioPlayer: btnSelectSound)
        app.selectedDiffculty = DifficultyType.easy
        transitionToPlay()
        normalBtn.isHidden = true
        hardBtn.isHidden = true
        impossibleBtn.isHidden = true
    }
    
    @IBAction func onClickNormalBtn(_ sender: UIButton) {
        Sound.play(audioPlayer: btnSelectSound)
        app.selectedDiffculty = DifficultyType.normal
        transitionToPlay()
        easyBtn.isHidden = true
        hardBtn.isHidden = true
        impossibleBtn.isHidden = true
    }
    
    @IBAction func onClickHardBtn(_ sender: UIButton) {
        if !UserDefaults.standard.bool(forKey: udKey.hard_mode_on) {
            Sound.play(audioPlayer: btnErorrSound)
            let alert = AlertUtil()
            let msg = String(format: NSLocalizedString("requirements_txt", comment: ""), DifficultyType.normal.getLocalizedString(), define.REQUIRED_LEVEL_HARD)
            alert.requirementsMode(title: NSLocalizedString("requirements", comment: ""), msg: msg, color: ColorUtil.hardmode)
            return
        }
        
        Sound.play(audioPlayer: btnSelectSound)
        app.selectedDiffculty = DifficultyType.hard
        transitionToPlay()
        easyBtn.isHidden = true
        normalBtn.isHidden = true
        impossibleBtn.isHidden = true
    }
    
    @IBAction func onClickImpossibleBtn(_ sender: UIButton) {
        if !UserDefaults.standard.bool(forKey: udKey.impossible_mode_on) {
            Sound.play(audioPlayer: btnErorrSound)
            let alert = AlertUtil()
            let msg = String(format: NSLocalizedString("requirements_txt", comment: ""), DifficultyType.hard.getLocalizedString(), define.REQUIRED_LEVEL_IMPOSSIBLE)
            alert.requirementsMode(title: NSLocalizedString("requirements", comment: ""), msg: msg, color: ColorUtil.impossiblemode)
            return
        }
        
        Sound.play(audioPlayer: btnSelectSound)
        app.selectedDiffculty = DifficultyType.impossible
        transitionToPlay()
        easyBtn.isHidden = true
        normalBtn.isHidden = true
        hardBtn.isHidden = true
    }
    
    
    
    func transitionToPlay() {
        let vc = Util.getForegroundViewController()
        vc.performSegue(withIdentifier: "toPlay", sender: self)
    }
    
}
