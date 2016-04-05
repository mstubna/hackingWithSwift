//
//  Board.swift
//  Project34
//
//  Created by Mike Stubna on 4/4/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import GameplayKit
import UIKit

enum ChipColor: Int {
    case Red = 0
    case Black
    case Blue
    case Green
    case Yellow
    case Purple
    case None
}

class Board: NSObject, GKGameModel {

    static var width = 7
    static var height = 6

    var slots = [ChipColor]()
    var currentPlayer: Player!

    override init() {
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
        for column in 0 ..< Board.width {
            if canMoveInColumn(column) { return false }
        }
        return true
    }

    func isWinForPlayer(player: GKGameModelPlayer) -> Bool {
        guard let chipColor = (player as? Player)?.chipColor else { return false }

        for row in 0 ..< Board.height {
            for col in 0 ..< Board.width {
                if squaresMatchChip(chipColor, row: row, col: col, moveX: 1, moveY: 0) {
                    return true
                } else if squaresMatchChip(chipColor, row: row, col: col, moveX: 0, moveY: 1) {
                    return true
                } else if squaresMatchChip(chipColor, row: row, col: col, moveX: 1, moveY: 1) {
                    return true
                } else if squaresMatchChip(chipColor, row: row, col: col, moveX: 1, moveY: -1) {
                    return true
                }
            }
        }

        return false
    }

    private func squaresMatchChip(
        chipColor: ChipColor,
        row: Int,
        col: Int,
        moveX: Int,
        moveY: Int
    ) -> Bool {
        // bail out early if we can't win from here
        if row + (moveY * 3) < 0 { return false }
        if row + (moveY * 3) >= Board.height { return false }
        if col + (moveX * 3) < 0 { return false }
        if col + (moveX * 3) >= Board.width { return false }

        // still here? Check every square
        if chipInColumn(col, row: row) != chipColor { return false }
        if chipInColumn(col + moveX, row: row + moveY) != chipColor { return false }
        if chipInColumn(col + (moveX * 2), row: row + (moveY * 2)) != chipColor { return false }
        if chipInColumn(col + (moveX * 3), row: row + (moveY * 3)) != chipColor { return false }

        return true
    }

    private func chipInColumn(column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }

    private func setChip(chip: ChipColor, column: NSInteger, row: NSInteger) {
        slots[row + column * Board.height] = chip
    }

    // MARK: NSCopying required Methods

    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }

    // MARK: GKGameModel required Methods

    func setGameModel(gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            slots = board.slots
            currentPlayer = board.currentPlayer
        }
    }

    func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let playerObject = player as? Player else { return nil }

        if isWinForPlayer(playerObject) || isWinForPlayer(playerObject.opponent) {
            return nil
        }

        var moves = [Move]()
        for column in 0 ..< Board.width {
            if canMoveInColumn(column) {
                moves.append(Move(column: column))
            }
        }
        return moves
    }

    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            addChip(currentPlayer.chipColor, column: move.column)
            currentPlayer = currentPlayer.opponent
        }
    }

    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        if let playerObject = player as? Player {
            if isWinForPlayer(playerObject) {
                return 1000
            } else if isWinForPlayer(playerObject.opponent) {
                return -1000
            }
        }
        return 0
    }

    var players: [GKGameModelPlayer]? {
        return [currentPlayer, currentPlayer.opponent]
    }

    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
}
