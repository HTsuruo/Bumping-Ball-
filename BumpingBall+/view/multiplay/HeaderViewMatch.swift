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
    
    var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let themeUtil = ThemeUtil()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func loadXib() {
        Bundle.main.loadNibNamed("HeaderViewMatch", owner: self, options: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: define.HEADER_HEIGHT)
        contentView.backgroundColor = themeUtil.getThemeColor(themeType: app.theme)
        self.addSubview(contentView)
    }
    
    func disappearAnimation(_ type: PlayerType, life: Int) {
        let view = SpringImageView()
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        switch type {
        case .player1:
            view.image = UIImage(named: "life_red")
            let image = UIImage(named: "life_red_empty")
            switch life {
            case 3:
                frame = lifeRedRight.frame
                lifeRedRight.image = image
            case 2:
                frame = lifeRedCenter.frame
                lifeRedCenter.image = image
            case 1:
                frame = lifeRedLeft.frame
                lifeRedLeft.image = image
            default:
                break
            }
            view.frame = frame
            leftArea.addSubview(view)
            
        case .player2:
            view.image = UIImage(named: "life_blue")
            let image = UIImage(named: "life_blue_empty")
            switch life {
            case 3:
                frame = lifeBlueRight.frame
                lifeBlueRight.image = image
            case 2:
                frame = lifeBlueCenter.frame
                lifeBlueCenter.image = image
            case 1:
                frame = lifeBlueLeft.frame
                lifeBlueLeft.image = image
            default:
                break
            }
            view.frame = frame
            rightArea.addSubview(view)
        }
        view.animation = "zoomOut"
        view.force = CGFloat(3.0)
        view.duration = 4.0
        view.animate()
    }
    
    func appearAnimation(_ type: PlayerType, life: Int) {
        let view = SpringImageView()
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        switch type {
        case .player1:
            let image = UIImage(named: "life_red")
            view.image = image
            switch life {
            case 3:
                frame = lifeRedRight.frame
                lifeRedRight.image = image
            case 2:
                frame = lifeRedCenter.frame
                lifeRedCenter.image = image
            case 1:
                frame = lifeRedLeft.frame
                lifeRedLeft.image = image
            default:
                break
            }
            view.frame = frame
            leftArea.addSubview(view)
            
        case .player2:
            let image = UIImage(named: "life_blue")
            view.image = image
            switch life {
            case 3:
                frame = lifeBlueRight.frame
                lifeBlueRight.image = image
            case 2:
                frame = lifeBlueCenter.frame
                lifeBlueCenter.image = image
            case 1:
                frame = lifeBlueLeft.frame
                lifeBlueLeft.image = image
            default:
                break
            }
            view.frame = frame
            rightArea.addSubview(view)
        }
        view.animation = "zoomIn"
        view.force = CGFloat(3.0)
        view.duration = 4.0
        view.animateNext {
            view.removeFromSuperview()
        }
    }
}
