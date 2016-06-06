//
//  NSDictionary+BlocksAdditionsTest.swift
//  JUtilsTests
//
//  Created by Vladimir Gorbenko on 15.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import XCTest

import iAsync_utils

class NSDictionary_BlocksAdditionsTest: XCTestCase {

    func testEachMethod() {

        let dict = [
            "1" : 1,
            "2" : 2,
            "3" : 3,
        ]

        let keys    = NSMutableArray()
        let objects = NSMutableArray()

        for (key, value) in dict {
            keys   .addObject(key  )
            objects.addObject(value)
        }

        XCTAssertEqual(3, keys.count)

        for key : AnyObject in (dict as NSDictionary).allKeys {
            XCTAssertTrue(keys.containsObject(key))
        }

        XCTAssertEqual(3, objects.count)
        
        for value : AnyObject in (dict as NSDictionary).allValues {
            XCTAssertTrue(objects.containsObject(value))
        }
    }

    func testAny() {

        let arr = ["a", "b", "c"]

        XCTAssertTrue(arr.any { $0 == "a" })
        XCTAssertTrue(arr.any { $0 == "b" })
        XCTAssertTrue(arr.any { $0 == "c" })
        XCTAssertFalse(arr.any { $0 == "d" })

        let emptyArr: [String] = []
        XCTAssertFalse(emptyArr.any { _ in true })
    }

    func testAllMethod() {

        let arr = ["a", "b", "c"]

        XCTAssertTrue(arr.all { $0.utf16.count == 1 } )
        XCTAssertFalse(arr.all { $0 == "a" || $0 == "b" } )

        let emptyArr: [String] = []
        XCTAssertTrue(emptyArr.all { _ in false })
    }
}
