//
//  AppDelegate.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let cache = URLCache.init(memoryCapacity: 4*1024*1024, diskCapacity: 20*1024*1024, diskPath: nil)
        URLCache.shared = cache
        MagicalRecord.setupCoreDataStack(withStoreNamed: "Model")
        
        let firstTime = UserDefaults.standard.bool(forKey: "FIRST_TIME")
        if firstTime{
            UserDefaults.standard.set(true, forKey: "FIRST_TIME")
            
        }
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = ExploreViewController.getInstance()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

