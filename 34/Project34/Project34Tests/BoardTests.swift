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

    func testIsWinForPlayerWithEmptyBoard() {
        for player in players {
            XCTAssert(
                !board.isWinForPlayer(player),
                "isWinForPlayer should be false with empty board"
            )
        }
    }

    func testIsWinForPlayerWithFourBlackChipsAcross() {
        for i in 0 ..< 4 {
            board.addChip(players[0].chipColor, column: i)
        }
        XCTAssert(board.isWinForPlayer(players[0]),
            "isWinForPlayer(Black) should be true with 4 Black across"
        )
        XCTAssert(
            !board.isWinForPlayer(players[1]),
            "isWinForPlayer(Red) should be false with 4 Black across"
        )
    }
}
