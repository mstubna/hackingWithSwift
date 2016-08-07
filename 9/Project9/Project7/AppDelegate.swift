//
//  AppDelegate.swift
//  Project7
//
//  Created by Mike Stubna on 12/2/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        // Override point for customization after application launch.
        guard let splitViewController = self.window!.rootViewController as?
            UISplitViewController else { return false }
        guard let navigationController = splitViewController
            .viewControllers[splitViewController.viewControllers.count-1] as? UINavigationController
            else { return false }
        navigationController.topViewController!.navigationItem.leftBarButtonItem =
            splitViewController.displayModeButtonItem()
        splitViewController.delegate = self

        guard let tabBarController = splitViewController.viewControllers[0] as? UITabBarController
            else { return false }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewControllerWithIdentifier("NavController") as?
            UINavigationController else { return false }
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .TopRated, tag: 1)

        tabBarController.viewControllers?.append(vc)

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

    // MARK: - Split view

    func splitViewController(
        splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController: UIViewController,
        ontoPrimaryViewController primaryViewController: UIViewController
    ) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController
            else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as?
            DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            return true
        }
        return false
    }

}
