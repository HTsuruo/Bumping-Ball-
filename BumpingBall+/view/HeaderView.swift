//
//  HeaderView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/19.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet var contentView: UIView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadXib() {
        NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
        contentView.frame = CGRectMake(0, 0, define.WIDTH, 60)
        self.addSubview(contentView)
    }
    

}
