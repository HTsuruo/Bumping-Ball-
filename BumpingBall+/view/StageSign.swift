//
//  StageSign.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/12/03.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import Spring

class StageSign: UIView {

    @IBOutlet var contentView: SpringView!
    @IBOutlet weak var label: SpringLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib(frame: frame)
        contentView.backgroundColor = ColorUtil.stageSignBk
        label.textColor = UIColor.white
        labelInAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadXib(frame: CGRect) {
        Bundle.main.loadNibNamed("StageSign", owner: self, options: nil)
        contentView.frame = frame
        contentView.center = CGFloat.CENTER
        self.addSubview(contentView)
    }
    
    func labelInAnimation() {
        label.animation = "squeezeRight"
        label.force = 2.0
        label.delay = 0.25
        label.duration = 1.0
        label.animateNext(completion: {
            self.labelOutAnimation()
        })
    }
    
    func labelOutAnimation() {
        label.animation = "fadeOut"
        label.delay = 1.0
        label.duration = 1.0
        contentView.animation = "fadeOut"
        contentView.delay = 1.2
        contentView.animate()
        label.animateNext(completion: {
            self.label.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
    
    func setNumber(stage: Int) {
        label.text = "S T A G E \(stage)"
    }
}
