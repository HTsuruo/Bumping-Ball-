//
//  ColorBallCell.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/12.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class ColorBallCell: UITableViewCell {

    
    @IBOutlet weak var colorBallIcon: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var subTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subTxt.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
