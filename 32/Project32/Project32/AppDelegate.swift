//
//  AppDelegate.swift
//  Project32
//
//  Created by Mike Stubna on 3/23/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import CoreSpotlight
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        // Override point for customization after application launch.
        guard let splitViewController = self.window!.rootViewController as? UISplitViewController
            else { return false }
        guard let navigationController =
            splitViewController.viewControllers[splitViewController.viewControllers.count-1] as?
            UINavigationController else { return false }
        navigationController.topViewController!.navigationItem.leftBarButtonItem =
            splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        return true
    }

    func application(
        application: UIApplication,
        continueUserActivity userActivity: NSUserActivity,
        restorationHandler: ([AnyObject]?) -> Void
    ) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            guard let uniqueIdentifier =
                userActivity.userInfo?[CSSearchableItemActivityIdentifier] as?
                String else { return true }
            guard let splitViewController = self.window!.rootViewController as?
                UISplitViewController else { return true }
            guard let navigationController =
                splitViewController.viewControllers[splitViewController.viewControllers.count-1] as?
                UINavigationController else { return true}
            if let masterVC = navigationController.topViewController as? MasterViewController {
                masterVC.showTutorial(Int(uniqueIdentifier)!)
            }
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}
