//
//  MasterViewController.swift
//  Project38
//
//  Created by Mike Stubna on 4/6/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import CoreData
import UIKit

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var networkController: NetworkController!
    var fetchedResultsController: NSFetchedResultsController!
    var commitPredicate: NSPredicate?
    var dateFormatter: NSDateFormatter!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            guard let navigationController = controllers[controllers.count-1] as?
                UINavigationController else { return }
            self.detailViewController = navigationController.topViewController as?
                DetailViewController
        }

        // obtain a reference to the networkController
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            networkController = delegate.networkController
        }

        // configure date formatting
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle

        // load data into the view
        loadDataIntoView()

        // request a data refresh
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(MasterViewController.loadDataIntoView),
            name: "dataRefreshed",
            object: nil
        )
        networkController.refreshData()

        // add the filter button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .Plain,
            target: self,
            action: #selector(MasterViewController.changeFilter)
        )
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadDataIntoView() {
        fetchedResultsController = networkController.getCommits()
        fetchedResultsController.delegate = self
        fetchedResultsController.fetchRequest.predicate = commitPredicate

        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("fetchedResultsController.performFetch() failed")
        }
    }

    func changeFilter() {
        let ac = UIAlertController(
            title: "Filter commits…", message: nil, preferredStyle: .ActionSheet
        )

        ac.addAction(UIAlertAction(
            title: "Show only fixes",
            style: .Default,
            handler: { [unowned self] _ in
                self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
                self.loadDataIntoView()
        }))

        ac.addAction(UIAlertAction(
            title: "Ignore Pull Requests",
            style: .Default,
            handler: { [unowned self] _ in
                self.commitPredicate = NSPredicate(
                    format: "NOT message BEGINSWITH 'Merge pull request'"
                )
                self.loadDataIntoView()
        }))

        ac.addAction(UIAlertAction(
            title: "Show only recent",
            style: .Default,
            handler: { [unowned self] _ in
                let twelveHoursAgo = NSDate().dateByAddingTimeInterval(-43200)
                self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo)
                self.loadDataIntoView()
        }))

        ac.addAction(UIAlertAction(
            title: "Show only Durian commits",
            style: .Default,
            handler: { [unowned self] _ in
                self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
                self.loadDataIntoView()
        }))

        ac.addAction(UIAlertAction(
            title: "Show all commits",
            style: .Default,
            handler: { [unowned self] _ in
                self.commitPredicate = nil
                self.loadDataIntoView()
        }))

        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "showDetail" { return }
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        guard let object = fetchedResultsController.objectAtIndexPath(indexPath) as? Commit
            else { return }
        guard let navigationController = segue.destinationViewController as? UINavigationController
            else { return }
        guard let controller = navigationController.topViewController as? DetailViewController
            else { return }
        controller.detailItem = object
        controller.navigationItem.leftBarButtonItem =
            self.splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        guard let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Commit
            else { return cell }
        cell.textLabel!.text = object.message
        let text = "By \(object.author.name) on \(dateFormatter.stringFromDate(object.date))"
        cell.detailTextLabel!.text = text

        return cell
    }

    override func tableView(
        tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath
    ) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(
        tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return fetchedResultsController.sections![section].name
    }
}
