//
//  PlayerTests.swift
//  Project34
//
//  Created by Mike Stubna on 4/4/16.
//  Copyright © 2016 Mike. All rights reserved.
//

@testable import Project34
import XCTest

class PlayerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPlayerColorShouldMatchChipColor() {
        XCTAssert(
            Player(chipColor: .Red).color == UIColor.redColor(),
            "color should return red"
        )
        XCTAssert(
            Player(chipColor: .Black).color == UIColor.blackColor(),
            "color should return black"
        )
    }

    func testNameColorShouldMatchChipColor() {
        for (index, name) in Player.names.enumerate() {
            XCTAssert(
                Player(chipColor: ChipColor(rawValue: index)!).name == name,
                "player.name should return \(name)"
            )
        }
    }
}
