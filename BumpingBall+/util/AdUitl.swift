//
//  AdUitl.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/11/12.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdUitl: GADBannerView, GADBannerViewDelegate {
    
    private let adMobId = "ca-app-pub-3081716991868318/5245059383"
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("admob success")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("admob failed")
    }
    
    func showBanner(vc: UIViewController, view: UIView, banner: GADAdSize) {
        let bannerView = GADBannerView(adSize: banner)
        let bannerHeight = banner.size.height
        bannerView.frame.origin = CGPoint(x: 0, y: CGFloat.HEIGHT - bannerHeight)
        bannerView.frame.size = CGSize(width: CGFloat.WIDTH, height: bannerHeight)
        bannerView.adUnitID = adMobId
        bannerView.delegate = self
        bannerView.rootViewController = vc
        let request = GADRequest()
//        request.testDevices = ["2271c3f1fb9b3bcbc4a426d7d2f970b7"]
        bannerView.load(request)
        view.addSubview(bannerView)
    }

}
