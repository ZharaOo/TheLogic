//
//  AppDelegate.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8013517248040410~3812580147")
        
        let nb = UINavigationBar.appearance()
        nb.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        nb.shadowImage = UIImage.init()
        nb.isTranslucent = true
        
        return true
    }
}

