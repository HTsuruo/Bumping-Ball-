//
//  AutoPauseView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/22.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WaitingView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var txt: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        hide()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadXib() {
        Bundle.main.loadNibNamed("WaitingView", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
        indicator.frame.size = CGSize(width: 70, height: 70)
        self.addSubview(contentView)
    }
    
    func show() {
        self.isHidden = false
        indicator.startAnimating()
    }
    
    func hide() {
        self.isHidden = true
        indicator.stopAnimating()
    }

}
