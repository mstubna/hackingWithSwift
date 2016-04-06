//
//  Commit+CoreDataProperties.swift
//  Project38
//
//  Created by Mike Stubna on 4/6/16.
//  Copyright © 2016 Mike. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Commit {

    @NSManaged var date: NSDate
    @NSManaged var message: String
    @NSManaged var sha: String
    @NSManaged var url: String

}
