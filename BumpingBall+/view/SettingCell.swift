//
//  FormViewCell.swift
//  Facename
//
//  Created by Tsuru on H28/10/15.
//  Copyright © 平成28年 Tsuru. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    var settingType: SettingType = SettingType.music
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = ColorUtil.text
        contentLabel.isHidden = true
        switchBtn.isHidden = true
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onChangeSwitch(_ sender: UISwitch) {
        let ud = UserDefaults.standard
        switch settingType {
        case .music:
            ud.set(!sender.isOn, forKey: udKey.off_music)
            break
        case .sound:
            ud.set(!sender.isOn, forKey: udKey.off_sound)
            break
        default:
            break
        }
    }
}
