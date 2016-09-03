//
//  HeaderViewMatch.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/09/03.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Spring

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
    
    @IBOutlet weak var leftArea: UIView!
    @IBOutlet weak var rightArea: UIView!
    
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
    
    func disapperAnimation(type: PlayerType, life: Int) {
        let view = SpringImageView()
        var frame = CGRectMake(0, 0, 0, 0)
        
        switch type {
        case .PLAYER1:
            view.image = UIImage(named: "life_red")
            switch life {
            case 3:
                frame = lifeRedRight.frame
                lifeRedRight.image = UIImage(named: "life_red_empty")
            case 2:
                frame = lifeRedCenter.frame
                lifeRedCenter.image = UIImage(named: "life_red_empty")
            case 1:
                frame = lifeRedLeft.frame
                lifeRedLeft.image = UIImage(named: "life_red_empty")
            default:
                break
            }
            view.frame = frame
            leftArea.addSubview(view)
            
        case .PLAYER2:
            view.image = UIImage(named: "life_blue")
            switch life {
            case 3:
                frame = lifeBlueRight.frame
                lifeBlueRight.image = UIImage(named: "life_blue_empty")
            case 2:
                frame = lifeBlueCenter.frame
                lifeBlueCenter.image = UIImage(named: "life_blue_empty")
            case 1:
                frame = lifeBlueLeft.frame
                lifeBlueLeft.image = UIImage(named: "life_blue_empty")
            default:
                break
            }
            view.frame = frame
            rightArea.addSubview(view)
        }
        view.animation = "fadeOut"
        view.scaleX = 2.5
        view.scaleY = 2.5
        view.duration = 6.0
        view.animate()
    }
}
