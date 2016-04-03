//
//  Whistle.swift
//  Project33
//
//  Created by Mike Stubna on 4/3/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import CloudKit
import UIKit

class Whistle: NSObject {
    var recordID: CKRecordID!
    var genre: String!
    var comments: String!
    var audio: NSURL!
}
