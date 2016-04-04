//
//  Board.swift
//  Project34
//
//  Created by Mike Stubna on 4/4/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

enum ChipColor: Int {
    case None = 0
    case Red
    case Black
}

class Board: NSObject {

    static var width = 7
    static var height = 6
    var slots = [ChipColor]()
    var currentPlayer: Player

    override init() {
        currentPlayer = Player.allPlayers[0]

        for _ in 0 ..< Board.width * Board.height {
            slots.append(.None)
        }

        super.init()
    }

    func canMoveInColumn(column: Int) -> Bool {
        return nextEmptySlotInColumn(column) != nil
    }

    func addChip(chip: ChipColor, column: Int) {
        if let row = nextEmptySlotInColumn(column) {
            setChip(chip, column: column, row: row)
        }
    }

    func nextEmptySlotInColumn(column: Int) -> Int? {
        for row in 0 ..< Board.height {
            if chipInColumn(column, row: row) == .None {
                return row
            }
        }

        return nil
    }

    func isFull() -> Bool {
        return false
    }

    func isWinForPlayer(player: Player) -> Bool {
        return false
    }

    private func chipInColumn(column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }

    private func setChip(chip: ChipColor, column: NSInteger, row: NSInteger) {
        slots[row + column * Board.height] = chip
    }
}
