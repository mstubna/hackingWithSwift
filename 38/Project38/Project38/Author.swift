//
//  Author.swift
//  Project38
//
//  Created by Mike Stubna on 4/6/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import Foundation
import CoreData


class Author: NSManagedObject {

    func orderedCommits() -> [Commit] {
        guard let result = commits.allObjects as? [Commit] else { return [Commit]() }
        return result.sort { return $0.date.compare($1.date) == .OrderedAscending }
    }

    func indexOfCommit(commit: Commit) -> Int? {
        for (index, c) in orderedCommits().enumerate() {
            if c.sha == commit.sha { return index }
        }
        return nil
    }
}
