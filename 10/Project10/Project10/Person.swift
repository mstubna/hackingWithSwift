//
//  Person.swift
//  Project10
//
//  Created by Mike Stubna on 12/12/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
