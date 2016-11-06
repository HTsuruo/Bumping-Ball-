//
//  GameCenterUtil.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/08/28.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import GameKit

struct GameCenterUtil {
    static var localPlayer: GKLocalPlayer = GKLocalPlayer()
    
    static func login(_ target: UIViewController) {
        self.localPlayer = GKLocalPlayer.localPlayer()
        self.localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController) != nil {
                print("LoginCheck: Failed - LoginPageOpen")
                target.present(viewController!, animated: true, completion: nil)
            } else {
                print("LoginCheck: Success")
                if error == nil {
                    print("LoginAuthentication: Success")
                } else {
                    print("LoginAuthentication: Failed")
                }
            }
        }
    }
    
    static func sendScore(_ value: Int, leaderBoardId: String) {
        let score = GKScore()
        score.value = Int64(value)
        score.leaderboardIdentifier = leaderBoardId
        let scoreArr: [GKScore] = [score]
        GKScore.report(scoreArr) { (error) in
            if error != nil {
                print("Report: Error")
            } else {
                print("Report: OK")
            }
        }
    }
    
}
