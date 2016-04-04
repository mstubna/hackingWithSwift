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
        XCTAssert(
            Player(chipColor: .Red).name == "Red",
            "name should return 'Red'"
        )
        XCTAssert(
            Player(chipColor: .Black).name == "Black",
            "name should return 'Black'"
        )
    }
}
