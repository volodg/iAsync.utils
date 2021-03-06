//
//  NSObject+OwnershipsTest.swift
//  JUtilsTests
//
//  Created by Vladimir Gorbenko on 14.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import XCTest

import Foundation

import iAsync_utils

class NSObject_OwnershipsTest: XCTestCase {

    func testObjectOwnershipsExtension() {

        weak var ownedDeallocated: NSObject?

        autoreleasepool {

            let owner = NSObject()

            autoreleasepool {

                let owned = NSObject()
                ownedDeallocated = owned
                owner.addOwnedObject(owned)
            }

            XCTAssertNotNil(ownedDeallocated, "Owned should not be dealloced")
        }

        XCTAssertNil(ownedDeallocated, "Owned should be dealloced")
    }
}
