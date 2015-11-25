//
//  ViewController.swift
//  Project4
//
//  Created by Mike Stubna on 11/25/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: "openTapped")
    }

    func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .Default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .Default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func openPage(alertAction: UIAlertAction) {
        if let title = alertAction.title {
            let url = NSURL(string: "https://www.\(title)")!
            webView.loadRequest(NSURLRequest(URL: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

