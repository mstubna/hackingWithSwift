//
//  DetailViewController.swift
//  Project38
//
//  Created by Mike Stubna on 4/6/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!

    var detailItem: Commit?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self

        configureView()
    }

    func configureView() {
        guard let commit = self.detailItem else { return }
        let index = commit.author.indexOfCommit(commit) ?? -1
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Commit \(index+1)/\(commit.author.commits.count)",
            style: .Plain,
            target: self,
            action: #selector(DetailViewController.showAuthorCommits)
        )

        if let url = NSURL(string: commit.url) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }

    func showAuthorCommits() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
