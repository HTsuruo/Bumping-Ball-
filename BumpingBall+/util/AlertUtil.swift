//
//  AlertUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/21.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SCLAlertView
import FontAwesomeKit

class AlertUtil: NSObject {
    
    override init() {
        print("AlertUtil init.")
    }
    
    func connectionError() {
        let alertView = SCLAlertView()
        alertView.showError(NSLocalizedString("connection_error_title", comment: ""), subTitle: NSLocalizedString("connection_error_subtitle", comment: ""))
    }
    
    func eroorMsgWithCloseBtn(title: String, msg: String) {
        let appearance = SCLAlertView.SCLAppearance()
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showError(title, subTitle: msg)
    }
    
    func eroorMsg(title: String, msg: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showError(title, subTitle: msg, duration: 1.0)
    }
    
    func eroorMsgWithOk(title: String, msg: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK") { }
        alertView.showError(title, subTitle: msg)
    }
    
    func success(title: String, msg: String) {
        let appearance = SCLAlertView.SCLAppearance(
            shouldAutoDismiss: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showSuccess(title, subTitle: msg, duration: 3.0)
    }
    
    func versionUpdate() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            shouldAutoDismiss: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let size = CGSize(width: 22, height: 22)
        let icon = FAKFontAwesome.levelUpIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let title = NSLocalizedString("update_info_title", comment: "")
        let subTitle = NSLocalizedString("update_info_subtitle", comment: "")
        alertView.addButton(NSLocalizedString("update_yes", comment: ""), backgroundColor: ColorUtil.goldbk, textColor: UIColor.white, showDurationStatus: false, action: {
            let url = NSURL(string: define.APPSTORE_URL)
            if UIApplication.shared.canOpenURL(url as! URL) {
                UIApplication.shared.openURL(url as! URL)
            }
        })
        alertView.addButton(NSLocalizedString("update_no", comment: ""), backgroundColor: UIColor.gray, textColor: UIColor.white, showDurationStatus: false, action: {
            alertView.hideView()
        })
        alertView.showCustom(title, subTitle: subTitle, color: ColorUtil.goldbk, icon: (icon?.image(with: size))!)
    }
    
    func custom(title: String, msg: String) {
        let appearance = SCLAlertView.SCLAppearance(
            shouldAutoDismiss: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let size = CGSize(width: 22, height: 22)
        let icon = FAKFontAwesome.infoIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        alertView.showCustom(title, subTitle: msg, color: ColorUtil.goldbk, icon: (icon?.image(with: size))!)
    }

}
