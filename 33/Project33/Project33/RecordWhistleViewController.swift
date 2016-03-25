//
//  RecordWhistleViewController.swift
//  Project33
//
//  Created by Mike Stubna on 3/25/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class RecordWhistleViewController: UIViewController {

    var stackView: UIStackView!

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.grayColor()

        stackView = UIStackView()
        stackView.spacing = 30
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
