//
//  AlertUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/21.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import SCLAlertView

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

}
