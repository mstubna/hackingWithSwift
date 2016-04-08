//
//  NetworkController.swift
//  Project38
//
//  Created by Mike Stubna on 4/7/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import CoreData
import Foundation

class NetworkController: NSObject {

    let dataURL = "https://api.github.com/repos/apple/swift/commits?per_page=100"
    var managedObjectContext: NSManagedObjectContext!
    let dateFormatISO8601 = "yyyy-MM-dd'T'HH:mm:ss'Z'"

    override init() {
        super.init()
        startCoreData()
    }

    // MARK: - Public interface

    // Returns the current set of commits
    func getCommits() -> NSFetchedResultsController {
        let fetch = NSFetchRequest(entityName: "Commit")
        fetch.sortDescriptors = [
            NSSortDescriptor(key: "author.name", ascending: true),
            NSSortDescriptor(key: "date", ascending: false)
        ]
        fetch.fetchBatchSize = 20

        return NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: "author.name",
            cacheName: nil
        )
    }

    // Requests a data refresh. Callers should subscribe to the 'dataRefreshed' notification
    func refreshData() {
        performSelectorInBackground(#selector(NetworkController.fetchCommits), withObject: nil)
    }

    // MARK: - Core Data functionality

    // initialize core data
    private func startCoreData() {
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
                NSSQLiteStoreType,
                configuration: nil,
                URL: url,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ]
            )

            // create managed object context
            managedObjectContext = NSManagedObjectContext(
                concurrencyType: .MainQueueConcurrencyType
            )
            managedObjectContext.persistentStoreCoordinator = coordinator
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        } catch {
            print("Failed to initialize the application's saved data")
            return
        }
    }

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
            self.configureCommits(jsonCommitArray)
            self.saveContext()
            self.notifyDataRefresh()
        }
    }

    private func notifyDataRefresh() {
        NSNotificationCenter.defaultCenter().postNotificationName("dataRefreshed", object: nil)
    }

    func configureCommits(jsonCommitArray: [JSON]) {
        for jsonCommit in jsonCommitArray {
            if let commit = NSEntityDescription.insertNewObjectForEntityForName(
                "Commit",
                inManagedObjectContext: managedObjectContext
                ) as? Commit {
                configureCommit(commit, usingJSON: jsonCommit)
            }
        }
    }

    private func configureCommit(commit: Commit, usingJSON json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue

        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")
        formatter.dateFormat = dateFormatISO8601
        commit.date = formatter.dateFromString(
            json["commit"]["committer"]["date"].stringValue
            ) ?? NSDate()

        var commitAuthor: Author!

        // see if this author already exists
        let authorFetchRequest = NSFetchRequest(entityName: "Author")
        authorFetchRequest.predicate = NSPredicate(
            format: "name == %@",
            json["commit"]["committer"]["name"].stringValue
        )

        let result = try? managedObjectContext.executeFetchRequest(authorFetchRequest)
        if let authors = result as? [Author] {
            if authors.count > 0 { commitAuthor = authors[0] }
        }

        // a saved author wasn't found so create a new one
        if commitAuthor == nil {
            let result = NSEntityDescription.insertNewObjectForEntityForName(
                "Author",
                inManagedObjectContext: managedObjectContext
            )
            if let author = result as? Author {
                author.name = json["commit"]["committer"]["name"].stringValue
                author.email = json["commit"]["committer"]["email"].stringValue
                commitAuthor = author
            }
        }

        // set the commit author
        commit.author = commitAuthor
    }

    // attempt to persist changed data
    private func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    // helper function to find the user's documents directory
    private func getDocumentsDirectory() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask
        )
        return urls[0]
    }

}
