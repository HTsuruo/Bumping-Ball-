//
//  extension.swift
//
//
//  Created by Tsuru on H28/09/22.
//
//

import UIKit

//UIColorのextensionとして登録しておく
extension UIColor {
    class func hex (hexStr: NSString, alpha: CGFloat) -> UIColor {
        let alpha = alpha
        var hexStr = hexStr
        hexStr = hexStr.replacingOccurrences(of: "#", with: "") as NSString
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r, green:g, blue:b, alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.white
        }
    }
}

extension UIApplication {
    //最前面のUIVIewControllerを取得
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
    
    //status barのところは時刻などを見やすくするためにあけてあげる.
    static func setStatusBar(_ parentView: UIView) {
        let v: UIView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.WIDTH, height: CGFloat.STATUS_HEIGHT))
        v.backgroundColor = UIColor.white
        parentView.addSubview(v)
    }
}

extension CGFloat {
    static let WIDTH: CGFloat = UIScreen.main.bounds.size.width
    static let HEIGHT: CGFloat = UIScreen.main.bounds.size.height
    static let STATUS_HEIGHT: CGFloat = UIApplication.shared.statusBarFrame.height
    static let CENTER: CGPoint = CGPoint(x: WIDTH/2, y: HEIGHT/2)
}
