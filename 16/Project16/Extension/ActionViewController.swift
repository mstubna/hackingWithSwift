//
//  ActionViewController.swift
//  Extension
//
//  Created by Mike Stubna on 12/29/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!

    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done,
            target: self, action: "done"
        )

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "adjustForKeyboard:",
            name: UIKeyboardWillHideNotification, object: nil
        )
        notificationCenter.addObserver(
            self, selector: "adjustForKeyboard:", name: UIKeyboardWillChangeFrameNotification,
            object: nil
        )

        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil)
                { [unowned self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues =
                        itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as?
                        NSDictionary else { return }

                    if let pageTitle = javaScriptValues["title"] as? String {
                        self.pageTitle = pageTitle
                    }

                    if let pageURL = javaScriptValues["URL"] as? String {
                        self.pageURL = pageURL
                    }

                    dispatch_async(dispatch_get_main_queue()) {
                        self.title = self.pageTitle
                    }
                }
            }
        }
    }

    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!

        guard let temp = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = temp.CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)

        if notification.name == UIKeyboardWillHideNotification {
            script.contentInset = UIEdgeInsetsZero
        } else {
            script.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height,
                right: 0
            )
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let webDictionary = [NSExtensionJavaScriptFinalizeArgumentKey:
            ["customJavaScript": script.text]]
        let customJavaScript = NSItemProvider(
            item: webDictionary,
            typeIdentifier: kUTTypePropertyList as String
        )
        item.attachments = [customJavaScript]

        extensionContext!.completeRequestReturningItems([item], completionHandler: nil)
    }
}
