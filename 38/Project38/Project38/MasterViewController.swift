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
    var objects = [Commit]()
    var managedObjectContext: NSManagedObjectContext!

    let dataURL = "https://api.github.com/repos/apple/swift/commits?per_page=100"
    let dateFormatISO8601 = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    let dateFormatter = NSDateFormatter()

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

        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle

        startCoreData()
        loadSavedDataIntoView()
        performSelectorInBackground(#selector(MasterViewController.fetchCommits), withObject: nil)
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadSavedDataIntoView() {
        let fetch = NSFetchRequest(entityName: "Commit")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetch.sortDescriptors = [sort]

        do {
            if let commits = try managedObjectContext.executeFetchRequest(fetch) as? [Commit] {
                print("Loaded \(commits.count) from memory.")
                objects = commits
                tableView.reloadData()
            }
        } catch {
            print("Could not load commits from memory.")
        }
    }

    // MARK: - Data fetching from API

    func fetchCommits() {
        print("Attempting to fetch new commits.")
        guard let data = NSData(contentsOfURL: NSURL(string: dataURL)!) else {
            print("Could not fetch new commits.")
            return
        }
        let jsonCommits = JSON(data: data)
        let jsonCommitArray = jsonCommits.arrayValue

        print("Received \(jsonCommitArray.count) new commits.")

        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            for jsonCommit in jsonCommitArray {
                if let commit = NSEntityDescription.insertNewObjectForEntityForName(
                    "Commit",
                    inManagedObjectContext: self.managedObjectContext
                ) as? Commit {
                    self.configureCommit(commit, usingJSON: jsonCommit)
                }
            }

            self.saveContext()
            self.loadSavedDataIntoView()
        }
    }

    func configureCommit(commit: Commit, usingJSON json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue

        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")
        formatter.dateFormat = dateFormatISO8601
        commit.date = formatter.dateFromString(
            json["commit"]["committer"]["date"].stringValue
        ) ?? NSDate()
    }

    // MARK: - Core Data persistence

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
        let object = objects[indexPath.row]
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

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.message
        cell.detailTextLabel!.text = dateFormatter.stringFromDate(object.date)

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
