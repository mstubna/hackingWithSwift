//
//  ViewController.swift
//  Project28
//
//  Created by Mike Stubna on 3/15/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!

    @IBAction func authenticateUser(sender: UIButton) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(
                .DeviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) {
                [unowned self] (success: Bool, authenticationError: NSError?) -> Void in

                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        self.unlockSecretMessage()
                        return
                    }
                    if let error = authenticationError {
                        if error.code == LAError.UserFallback.rawValue {
                            let ac = UIAlertController(
                                title: "Passcode? Ha!",
                                message: "It's Touch ID or nothing – sorry!",
                                preferredStyle: .Alert
                            )
                            ac.addAction(
                                UIAlertAction(title: "OK", style: .Default, handler: nil)
                            )
                            self.presentViewController(ac, animated: true, completion: nil)
                            return
                        }
                    }

                    let ac = UIAlertController(
                        title: "Authentication failed",
                        message: "Your fingerprint could not be verified; please try again.",
                        preferredStyle: .Alert
                    )
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                }
            }
        } else {
            let ac = UIAlertController(
                title: "Touch ID not available",
                message: "Your device is not configured for Touch ID.",
                preferredStyle: .Alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nothing to see here"

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "adjustForKeyboard:",
            name: UIKeyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self, selector: "adjustForKeyboard:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self, selector: "saveSecretMessage",
            name: UIApplicationWillResignActiveNotification,
            object: nil
        )
    }

    func unlockSecretMessage() {
        secret.hidden = false
        title = "Secret stuff!"

        if let text = KeychainWrapper.stringForKey("SecretMessage") {
            secret.text = text
        }
    }

    func saveSecretMessage() {
        if !secret.hidden {
            KeychainWrapper.setString(secret.text, forKey: "SecretMessage")
            secret.resignFirstResponder()
            secret.hidden = true
            title = "Nothing to see here"
        }
    }

    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!

        guard let keyboardScreenEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as?
            NSValue else { return }
        let keyboardScreenEndFrameValue = keyboardScreenEndFrame.CGRectValue()
        let keyboardViewEndFrame = view.convertRect(
            keyboardScreenEndFrameValue, fromView: view.window
        )

        if notification.name == UIKeyboardWillHideNotification {
            secret.contentInset = UIEdgeInsetsZero
        } else {
            secret.contentInset = UIEdgeInsets(
                top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0
            )
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
