//
//  HeaderViewMatch.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/09/03.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HeaderViewMatch: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerLabel1: UILabel!
    @IBOutlet weak var lifeRedLeft: UIImageView!
    @IBOutlet weak var lifeRedCenter: UIImageView!
    @IBOutlet weak var lifeRedRight: UIImageView!
    
    @IBOutlet weak var playerLabel2: UILabel!
    @IBOutlet weak var lifeBlueLeft: UIImageView!
    @IBOutlet weak var lifeBlueCenter: UIImageView!
    @IBOutlet weak var lifeBlueRight: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadXib() {
        NSBundle.mainBundle().loadNibNamed("HeaderViewMatch", owner: self, options: nil)
        contentView.frame = CGRectMake(0, 0, define.WIDTH, define.HEADER_HEIGHT)
        self.addSubview(contentView)
    }
    
    func disapperAnimation() {
        UIView.animateWithDuration(1, animations: {
            }, completion: { finished in
        })
    }
}
