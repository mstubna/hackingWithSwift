//
//  Move.swift
//  Project34
//
//  Created by Mike Stubna on 4/4/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {

    var value: Int = 0
    var column: Int

    init(column: Int) {
        self.column = column
    }
}
