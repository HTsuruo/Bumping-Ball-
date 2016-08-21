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
    
    private func loadNib() {
        NSBundle.mainBundle().loadNibNamed("TouchViewTxt", owner: self, options: nil)
        contentView.frame = CGRectMake(0, define.HEIGHT - define.TOUCH_HEIGHT, define.WIDTH, define.TOUCH_HEIGHT)
        self.addSubview(contentView)
    }
    
    private func hideSwipeArrows() {
        leftSwipeArrow.hidden = true
        rightSwipeArrow.hidden = true
    }
    
    private func showSwipeArrows() {
        leftSwipeArrow.hidden = false
        rightSwipeArrow.hidden = false
    }
    
    func chargeReset() {
        hideSwipeArrows()
        centerTxt.text = "Touch Here!!"
    }
    
    func chargeFull() {
        showSwipeArrows()
        centerTxt.text = "Swipe!!"
    }
}
