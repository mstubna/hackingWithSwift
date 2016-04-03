//
//  SubmitViewController.swift
//  Project33
//
//  Created by Mike Stubna on 4/3/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import CloudKit
import UIKit

class SubmitViewController: UIViewController {

    var genre: String!
    var comments: String!

    var stackView: UIStackView!
    var status: UILabel!
    var spinner: UIActivityIndicatorView!

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.grayColor()

        stackView = UIStackView()
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackViewDistribution.FillEqually
        stackView.alignment = UIStackViewAlignment.Center
        stackView.axis = .Vertical
        view.addSubview(stackView)

        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[stackView]|",
                options: NSLayoutFormatOptions.AlignAllCenterX,
                metrics: nil,
                views: ["stackView": stackView]
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: stackView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: view,
                attribute: .CenterY,
                multiplier: 1,
                constant:0
            )
        )

        status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Submitting…"
        status.textColor = UIColor.whiteColor()
        status.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        status.numberOfLines = 0
        status.textAlignment = .Center

        spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()

        stackView.addArrangedSubview(status)
        stackView.addArrangedSubview(spinner)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "You're all set!"
        navigationItem.hidesBackButton = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        doSubmission()
    }

    func doSubmission() {

    }

    func doneTapped() {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
