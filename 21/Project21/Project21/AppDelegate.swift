//
//  AppDelegate.swift
//  Project21
//
//  Created by Mike Stubna on 1/18/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var notification: UILocalNotification?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        if let options = launchOptions {
            if let localNotification = options[UIApplicationLaunchOptionsLocalNotificationKey] as?
            UILocalNotification {
                notification = localNotification
            }
        }
        return true
    }

    func application(
        application: UIApplication,
        didReceiveLocalNotification notification: UILocalNotification
    ) {
        if let data = getNotificationData(notification) {
            print("didReceiveLocalNotification: \(data)")
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // If the app was started via a local notification then display an alert
        guard let data = getNotificationData(notification) else { return }
        let ac = UIAlertController(
            title: "Alert",
            message: "App started with notification: \(data)",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.window?.rootViewController?.presentViewController(ac, animated: true, completion: nil)
        notification = nil
    }

    // Returns the custom data from a local notification, if it exists
    func getNotificationData (localNotification: UILocalNotification?) -> String? {
        if let userInfo = localNotification?.userInfo {
            if let customField1 = userInfo["CustomField1"] as? String {
                return customField1
            }
        }
        return nil
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This
        // can occur for certain types of temporary interruptions (such as an incoming phone call
        // or SMS message) or when the user quits the application and it begins the transition to
        // the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES
        // frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information to restore your application to its
        // current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of
        // applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can
        // undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also
        // applicationDidEnterBackground:.
    }

}
