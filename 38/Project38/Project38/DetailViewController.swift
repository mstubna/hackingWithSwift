//
//  DetailViewController.swift
//  Project38
//
//  Created by Mike Stubna on 4/6/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var detailItem: Commit? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        guard let commit = self.detailItem else { return }
        guard let label = self.detailDescriptionLabel else { return }
        label.text = commit.message
        let index = commit.author.indexOfCommit(commit) ?? -1
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Commit \(index+1)/\(commit.author.commits.count)",
            style: .Plain,
            target: self,
            action: #selector(DetailViewController.showAuthorCommits)
        )
    }

    func showAuthorCommits() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
