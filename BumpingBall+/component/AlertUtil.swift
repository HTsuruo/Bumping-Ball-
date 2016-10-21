//
//  AlertUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/10/21.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class AlertUtil: NSObject {
    
    var vc: UIViewController! = nil
    
    init(vc: UIViewController) {
        self.vc = vc
    }

    func common(title: String, msg: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(defaultAction)
        self.vc.present(alert, animated: true, completion: nil)
    }
    
}
