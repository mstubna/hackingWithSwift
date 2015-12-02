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
        
        guard let json = dataLoader.run(loadLiveData: true, option: option) else { return showError() }
        if json["metadata"]["responseInfo"]["status"].intValue == 200 {
            parseJSON(json, option: option)
            tableView.reloadData()
        } else {
            showError()
        }
    }
    
    func parseJSON(json: JSON, option: Int) {
        var results: [JSON]
        if option == 0 {
            results = json["results"].arrayValue.sort { $0["created"] > $1["created"] }
        } else {
            results = json["results"].arrayValue.sort { $0["signatureCount"] > $1["signatureCount"] }
        }
        
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
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
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
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }

}

