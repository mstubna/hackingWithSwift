//
//  ViewController.swift
//  Project21
//
//  Created by Mike Stubna on 1/18/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func registerLocal(sender: UIButton) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Alert, .Badge, .Sound],
            categories: nil
        )
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }

    @IBAction func scheduleLocal(sender: AnyObject) {
        guard let settings = UIApplication
            .sharedApplication().currentUserNotificationSettings() else { return }

        if settings.types == .None {
            let ac = UIAlertController(
                title: "Can't schedule",
                message: "Either we don't have permission to schedule notifications, or we " +
                         "haven't asked yet.",
                preferredStyle: .Alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }

        let notification = createLocalNotification()
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func createLocalNotification() -> UILocalNotification {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
        notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        return notification
    }
}
