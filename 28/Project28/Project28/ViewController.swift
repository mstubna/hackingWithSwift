//
//  ViewController.swift
//  Project28
//
//  Created by Mike Stubna on 3/15/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!

    @IBAction func authenticateUser(sender: UIButton) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
