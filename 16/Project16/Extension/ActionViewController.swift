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

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "done"
        )

        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                itemProvider.loadItemForTypeIdentifier(
                    kUTTypePropertyList as String,
                    options: nil
                ) { [unowned self] (dict, error) in
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
