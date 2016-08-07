//
//  MasterViewController.swift
//  Project7
//
//  Created by Mike Stubna on 12/2/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String: String]]()
    let dataLoader = DataLoader()

    override func viewDidLoad() {
        super.viewDidLoad()

        let option = navigationController?.tabBarItem.tag == 0 ? 0 : 1

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            if let results = self.dataLoader.run(loadLiveData: true, option: option) {
                self.parseJSON(results)
                dispatch_async(dispatch_get_main_queue()) {
                    [unowned self] in self.tableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in self.showError() }
            }
        }
    }

    func parseJSON(results: [JSON]) {
        for result in results {
            objects.append([
                "title": result["title"].stringValue,
                "body": result["body"].stringValue,
                "sigs": result["signatureCount"].stringValue,
                "created": result["created"].stringValue
            ])
        }
    }

    func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection.",
            preferredStyle: .Alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                guard let navController = segue.destinationViewController as? UINavigationController
                    else { return }
                guard let controller = navController.topViewController as? DetailViewController
                    else { return }
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem =
                    self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }
}
