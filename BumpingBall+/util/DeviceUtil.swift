//
//  DeviceUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/12/16.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class DeviceUtil: NSObject {
    
    static func getOptionalScale( width: CGFloat) -> Double {
        let devicewidth = DeviceWidth(rawValue: width)! as DeviceWidth
        switch devicewidth {
        case .inches_4_5:
            return  0.92
        case .inches_4_7:
            return  1.0
        case .inches_5_5:
            return  1.15
        }
    }
}

enum DeviceWidth: CGFloat {
    case inches_4_5 = 320.0
    case inches_4_7 = 375.0
    case inches_5_5 = 414.0
}
