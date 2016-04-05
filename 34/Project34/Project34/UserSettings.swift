//
//  UserSettings.swift
//  Project34
//
//  Created by Mike Stubna on 4/5/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import Foundation

class UserSettings {

    var twoPlayerMode: Bool = false {
        didSet { settingsChanged() }
    }

    func settingsChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName("settingsChanged", object: nil)
    }
}

let sharedUserSettings = UserSettings()
