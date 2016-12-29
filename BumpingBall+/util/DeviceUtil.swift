//
//  DeviceUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/12/16.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit

class DeviceUtil {
    
    static func getOptionalScale() -> Double {
        let deviceheight = DeviceHeight(rawValue: Double(CGFloat.HEIGHT))! as DeviceHeight
        switch deviceheight {
        case .inches_3_5:
            return  3.5 / define.BASE_DEVICE_INCH
        case .inches_4_0:
            return  4.0 / define.BASE_DEVICE_INCH
        case .inches_4_7:
            return  1.0
        case .inches_5_5:
            return  5.5 / define.BASE_DEVICE_INCH
        }
    }
    
    static func getOptionalSpeed() -> Double {
        return  Double(CGFloat.HEIGHT) / define.BASE_DEVICE_HEIGHT
    }
    
    static func getIncreaseScale() -> Double {
        let deviceheight = DeviceHeight(rawValue: Double(CGFloat.HEIGHT))! as DeviceHeight
        let basespeed = 0.04
        switch deviceheight {
        case .inches_3_5:
            return  basespeed * (3.5 / define.BASE_DEVICE_INCH)
        case .inches_4_0:
            return  basespeed * (4.0 / define.BASE_DEVICE_INCH)
        case .inches_4_7:
            return  basespeed
        case .inches_5_5:
            return  basespeed * (5.5 / define.BASE_DEVICE_INCH)
        }
    }
    
    static func inches_3_5() -> Bool {
        return CGFloat.WIDTH == 320.0 && CGFloat.HEIGHT == 480
    }
}

enum DeviceWidth: Double {
    case inches_4_0 = 320.0
    case inches_4_7 = 375.0
    case inches_5_5 = 414.0
}

enum DeviceHeight: Double {
    case inches_3_5 = 480.0
    case inches_4_0 = 568.0
    case inches_4_7 = 667.0
    case inches_5_5 = 736.0
}
