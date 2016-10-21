//
//  PrepareView.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/21.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class PrepareView: UIView {

    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadXib() {
        Bundle.main.loadNibNamed("PrepareView", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.HEIGHT)
        self.addSubview(contentView)
    }

}
