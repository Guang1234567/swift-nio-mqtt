//
//  NIOMQTTTests.swift
//  SwiftNIOMQTTTests
//
//  Created by Bofei Zhu on 6/11/19.
//  Copyright © 2019 HealthTap Inc. All rights reserved.
//

import XCTest
@testable import NIOMQTT

class NIOMQTTTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let integer = VInt(value: 12)
        XCTAssertEqual(integer.hasFollowing, false)
    }
}
