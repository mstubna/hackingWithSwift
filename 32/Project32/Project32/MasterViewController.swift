//
//  MasterViewController.swift
//  Project32
//
//  Created by Mike Stubna on 3/23/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var projects = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        projects.append(
            ["Project 1: Storm Viewer",
            "Constants and variables, UITableView, UIImageView, NSFileManager, storyboards"]
        )
        projects.append(
            ["Project 2: Guess the Flag",
            "@2x and @3x images, asset catalogs, integers, doubles, floats, " +
            "operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, " +
            "actions, string interpolation, UIAlertController"]
        )
        projects.append(
            ["Project 3: Social Media",
            "UIBarButtonItem, UIActivityViewController, the Social framework, NSURL"]
        )
        projects.append(
            ["Project 4: Easy Browser",
            "loadView(), WKWebView, delegation, classes and structs, NSURLRequest, UIToolbar, " +
            "UIProgressView., key-value observing"]
        )
        projects.append(
            ["Project 5: Word Scramble",
            "NSString, closures, method return values, booleans, NSRange"]
        )
        projects.append(
            ["Project 6: Auto Layout",
            "Get to grips with Auto Layout using practical examples and code"]
        )
        projects.append(
            ["Project 7: Whitehouse Petitions",
            "JSON, NSData, UITabBarController"]
        )
        projects.append(
            ["Project 8: 7 Swifty Words",
            "addTarget(), enumerate(), countElements(), find(), join(), property observers, " +
            "range operators."]
        )
    }

    override func tableView(
        tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath
    ) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath
    ) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let project = projects[indexPath.row]
        cell.textLabel?.attributedText =
            makeAttributedString(title: project[0], subtitle: project[1])
        return cell
    }

    func makeAttributedString(title title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes =
            [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline),
             NSForegroundColorAttributeName: UIColor.purpleColor()]
        let subtitleAttributes =
            [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)]

        let titleString = NSMutableAttributedString(
            string: "\(title)\n",
            attributes: titleAttributes
        )
        let subtitleString = NSAttributedString(
            string: subtitle,
            attributes: subtitleAttributes
        )
        titleString.appendAttributedString(subtitleString)
        return titleString
    }

    override func tableView(
        tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath
    ) {
    }


}
