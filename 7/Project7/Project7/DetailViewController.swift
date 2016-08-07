//
//  DetailViewController.swift
//  Project7
//
//  Created by Mike Stubna on 12/2/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: [String: String]!
    let numberFormatter = NSNumberFormatter()
    let dateFormatter = NSDateFormatter()
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    func cancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self,
            action: #selector(cancelButton)
        )
        
        guard detailItem != nil else { return }
        let body = detailItem["body"] ?? "none"
        let title = detailItem["title"] ?? "None"

        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let sigCount = numberFormatter.stringFromNumber(Int(detailItem["sigs"] ?? "0")!)!

        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let createdDate = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: Double(detailItem["created"] ?? "0")!))

        var html = "<html>"
        html += "<head>"
        html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
        html += "<style> body { font-family: helvetica; } </style>"
        html += "</head>"
        html += "<body>"
        html += "<h1>\(title)</h1><br>"
        html += body
        html += "<br><br>"
        html += "<p>Signatures: \(sigCount)</p>"
        html += "<p>Created: \(createdDate)</p>"
        html += "</body>"
        html += "</html>"
        webView.loadHTMLString(html, baseURL: nil)
    }
}