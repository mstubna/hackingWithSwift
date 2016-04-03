//
//  AddCommentsViewController.swift
//  Project33
//
//  Created by Mike Stubna on 4/3/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate {

    var genre: String!
    var comments: UITextView!
    let placeholder = "If you have any additional comments that might help identify your tune, " +
        "enter them here."

    override func loadView() {
        super.loadView()

        comments = UITextView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        view.addSubview(comments)

        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[comments]|",
                options: .AlignAllCenterX,
                metrics: nil,
                views: ["comments": comments]
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[comments]|",
                options: .AlignAllCenterY,
                metrics: nil,
                views: ["comments": comments]
            )
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Submit",
            style: .Plain,
            target: self,
            action: #selector(AddCommentsViewController.submitTapped)
        )
        comments.text = placeholder
    }

    func submitTapped() {
        let vc = SubmitViewController()
        vc.genre = genre

        if comments.text == placeholder {
            vc.comments = ""
        } else {
            vc.comments = comments.text
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
