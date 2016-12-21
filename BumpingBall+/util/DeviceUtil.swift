//
//  DeviceUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/12/16.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class DeviceUtil {
    
    static func getOptionalScale(width: CGFloat) -> Double {
        let devicewidth = DeviceWidth(rawValue: Double(width))! as DeviceWidth
        switch devicewidth {
        case .inches_4_5:
            return  4.5 / define.BASE_DEVICE_INCH
        case .inches_4_7:
            return  4.7 / define.BASE_DEVICE_INCH
        case .inches_5_5:
            return  5.5 / define.BASE_DEVICE_INCH
        }
    }
    
    static func getOptionalSpeed(height: Double) -> Double {
        return height / define.BASE_DEVICE_HEIGHT
    }
    
    static func getIncreaseScale(width: CGFloat) -> Double {
        let devicewidth = DeviceWidth(rawValue: Double(width))! as DeviceWidth
        let basespeed = 0.04
        switch devicewidth {
        case .inches_4_5:
            return  basespeed * (4.5 / define.BASE_DEVICE_INCH)
        case .inches_4_7:
            return  basespeed
        case .inches_5_5:
            return  basespeed * (5.5 / define.BASE_DEVICE_INCH)
        }
    }
}

enum DeviceWidth: Double {
    case inches_4_5 = 320.0
    case inches_4_7 = 375.0
    case inches_5_5 = 414.0
}

enum DeviceHeight: Double {
    case inches_4_5 = 568.0
    case inches_4_7 = 667.0
    case inches_5_5 = 736.0
}
