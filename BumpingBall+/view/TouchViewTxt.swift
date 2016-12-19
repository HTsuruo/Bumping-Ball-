//
//  TouchView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/21.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SpriteKit

class TouchViewTxt: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var centerTxt: UILabel!
    @IBOutlet weak var leftSwipeArrow: UIImageView!
    @IBOutlet weak var rightSwipeArrow: UIImageView!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        hideSwipeArrows()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadNib() {
        Bundle.main.loadNibNamed("TouchViewTxt", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: CGFloat.HEIGHT - define.TOUCH_HEIGHT, width: CGFloat.WIDTH, height: define.TOUCH_HEIGHT)
        self.addSubview(contentView)
    }
    
    fileprivate func hideSwipeArrows() {
        leftSwipeArrow.isHidden = true
        rightSwipeArrow.isHidden = true
    }
    
    fileprivate func showSwipeArrows() {
        leftSwipeArrow.isHidden = false
        rightSwipeArrow.isHidden = false
    }
    
    func chargeReset() {
        hideSwipeArrows()
        centerTxt.text = "Tap Here!!"
    }
    
    func chargeFull() {
        showSwipeArrows()
        centerTxt.text = "Swipe!!"
    }
}
