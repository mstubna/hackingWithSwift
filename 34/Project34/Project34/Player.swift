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

    static let names = ["Red", "Black", "Blue", "Green", "Yellow", "Purple"]
    static let colors: [UIColor] = [
        .redColor(), .blackColor(), .blueColor(), .greenColor(), .yellowColor(), .purpleColor()
    ]

    var chipColor: ChipColor
    var color: UIColor
    var name: String
    var playerId: Int
    var opponent: Player!

    init(chipColor: ChipColor) {
        self.chipColor = chipColor
        playerId = chipColor.rawValue
        name = Player.names[chipColor.rawValue]
        color = Player.colors[chipColor.rawValue]
        super.init()
    }

    func updateColor(index: Int) {
        self.chipColor = ChipColor(rawValue: index) ?? ChipColor.None
        name = Player.names[index]
        color = Player.colors[index]
    }
}
