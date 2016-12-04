//
//  AppDelegate.swift
//  BumpingBall+
//
//  Created by Tsuru on H28/03/31.
//  Copyright © 平成28年 Hideki Tsuruoka. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import MultipeerConnectivity
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isStart: Bool?
    var score: Int? = 0
    var selectedDiffculty = DifficultyType.normal
    var selectedPlay = PlayType.one
    var bluetoothSession: MCSession? = nil
    var music: SKAudioNode? = nil
    var level = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        // GameCenter Auto Login
        if let presentView = window?.rootViewController {
            let targetViewController = presentView
            GameCenterUtil.login(targetViewController)
        }
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = ColorUtil.main
        
//        let notificationSettings = UIUserNotificationSettings(
//            types: [.badge, .sound, .alert], categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
//        application.registerForRemoteNotifications()
//        FIRApp.configure()
        
        setInitialViewController()
        Bgm.setCategoryAmbient()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if bluetoothSession != nil {
            bluetoothSession?.disconnect()
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
//        var tokenString = ""
//        
//        for i in 0..<deviceToken.count {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
//        
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
    }
    
    func setInitialViewController() {
        let isNotFirst = UserDefaults.standard.bool(forKey: udKey.is_not_first)
        var initialViewController: UIViewController! = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if isNotFirst {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "topVC")
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "tutorialVC")
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
}
