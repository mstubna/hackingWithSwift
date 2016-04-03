//
//  SelectGenreViewController.swift
//  Project33
//
//  Created by Mike Stubna on 4/3/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class SelectGenreViewController: UITableViewController {

    static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop",
                         "Reggae", "RnB", "Rock", "Soul"]


    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select genre"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Genre", style: .Plain, target: nil, action: nil
        )
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectGenreViewController.genres.count
    }

    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = SelectGenreViewController.genres[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        return cell
    }

    override func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
    ) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let genre = cell.textLabel?.text ?? SelectGenreViewController.genres[0]
            let vc = AddCommentsViewController()
            vc.genre = genre
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
