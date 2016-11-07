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
        alertView.showError("接続エラー", subTitle: "電波状況の良い環境で再度お試しください")
    }
    
    func eroorMsg(title: String, msg: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showError(title, subTitle: msg, duration: 2.0)
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
            shouldAutoDismiss: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let size = CGSize(width: 22, height: 22)
        let icon = FAKFontAwesome.pencilIcon(withSize:size.width)
        icon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let title = "アップデートのお知らせ"
        let subTitle = "新しいバージョンで遊べます\nAppStoreよりアップデートしてください"
        alertView.addButton("アップデートする", backgroundColor: ColorUtil.main, textColor: UIColor.white, showDurationStatus: false, action: {
            let url = NSURL(string: define.APPSTORE_URL)
            if UIApplication.shared.canOpenURL(url as! URL) {
                UIApplication.shared.openURL(url as! URL)
            }
        })
        alertView.showCustom(title, subTitle: subTitle, color: ColorUtil.main, icon: (icon?.image(with: size))!)
    }

}
