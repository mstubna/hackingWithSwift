//
//  MasterViewController.swift
//  Project38
//
//  Created by Mike Stubna on 4/6/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import CoreData
import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            guard let navigationController = controllers[controllers.count-1] as?
                UINavigationController else { return }
            self.detailViewController = navigationController.topViewController as?
                DetailViewController
        }

        startCoreData()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Core Data

    // initialize core data functionality
    func startCoreData() {
        // load the data model
        let modelURL = NSBundle.mainBundle().URLForResource("Project38", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!

        // create the persistent store coordinator
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        // fetch location of db
        let url = getDocumentsDirectory().URLByAppendingPathComponent("Project38.sqlite")

        do {
            // load db into persistent store coordinator
            try coordinator.addPersistentStoreWithType(
                NSSQLiteStoreType, configuration: nil, URL: url, options: nil
            )

            // create managed object context
            managedObjectContext = NSManagedObjectContext(
                concurrencyType: .MainQueueConcurrencyType
            )
            managedObjectContext.persistentStoreCoordinator = coordinator

        } catch {
            print("Failed to initialize the application's saved data")
            return
        }
    }

    // attempt to persist changed data
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    // helper function to find the user's documents directory
    func getDocumentsDirectory() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask
        )
        return urls[0]
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "showDetail" { return }
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        guard let object = objects[indexPath.row] as? NSDate else { return }
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

        if let object = objects[indexPath.row] as? NSDate {
            cell.textLabel!.text = object.description
        }
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
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath
    ) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array,
            // and add a new row to the table view.
        }
    }
}
