//
//  AppDelegate.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == Constants.ACTION_SETTINGS {
            let rootNavigationViewController = window!.rootViewController as? UINavigationController
            let rootViewController = rootNavigationViewController?.viewControllers.first as UIViewController?
            rootNavigationViewController?.popToRootViewController(animated: false)
            rootViewController?.performSegue(withIdentifier: Constants.SEGUE_SETTINGS, sender: nil)
        }
    }

}

