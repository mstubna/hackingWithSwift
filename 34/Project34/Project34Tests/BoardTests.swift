//
//  BoardTests.swift
//  Project34
//
//  Created by Mike Stubna on 4/4/16.
//  Copyright © 2016 Mike. All rights reserved.
//

@testable import Project34
import XCTest

class BoardTests: XCTestCase {

    var board: Board!
    var players: [Player]!

    override func setUp() {
        super.setUp()

        players = [
            Player(chipColor: .Red),
            Player(chipColor: .Black)
        ]

        players[0].opponent = players[1]
        players[1].opponent = players[0]

        board = Board(currentPlayer: players[0])
    }

    override func tearDown() {
        super.tearDown()
    }

    func testIsFullWithEmptyBoard() {
        XCTAssert(!board.isFull(), "isFull should return false for a new board")
    }

    func testIsFullWithFullBoard() {
        for i in 0 ..< Board.width {
            for _ in 0 ..< Board.height {
                board.addChip(.Black, column: i)
            }
        }
        XCTAssert(board.isFull(), "isFull should return true for a board a chip in every spot")
    }

    func testExample() {
        XCTAssert(true)
    }
}
