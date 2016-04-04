//
//  Player.swift
//  Project34
//
//  Created by Mike Stubna on 4/4/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import GameplayKit
import UIKit

class Player: NSObject, GKGameModelPlayer {

    var chipColor: ChipColor
    var color: UIColor
    var name: String
    var playerId: Int
    var opponent: Player!

    init(chipColor: ChipColor) {
        self.chipColor = chipColor
        self.playerId = chipColor.rawValue

        if chipColor == .Red {
            color = .redColor()
            name = "Red"
        } else {
            color = .blackColor()
            name = "Black"
        }

        super.init()
    }
}
