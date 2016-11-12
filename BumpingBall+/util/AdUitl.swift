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
    var bannerView = GADBannerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Admob広告設定
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(vc: UIViewController) {
        // Admobで発行された広告ユニットIDを設定
        bannerView.adUnitID = adMobId
        bannerView.delegate = self
        bannerView.rootViewController = vc
        let request = GADRequest()
//        request.testDevices = ["2271c3f1fb9b3bcbc4a426d7d2f970b7"]
        bannerView.load(request)
        vc.view.addSubview(bannerView)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("admob success")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("admob failed")
    }

}
