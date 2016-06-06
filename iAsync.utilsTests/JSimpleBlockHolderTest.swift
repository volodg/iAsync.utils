//
//  JSimpleBlockHolderTest.swift
//  JUtilsTests
//
//  Created by Vladimir Gorbenko on 14.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import XCTest

import iAsync_utils

class JSimpleBlockHolderTest: XCTestCase {

    func testSimpleBlockHolderBehavior()  {

        weak var weakHolder: SimpleBlockHolder?

        autoreleasepool {
            let strongHolder: SimpleBlockHolder? = SimpleBlockHolder()
            weakHolder = strongHolder

            weak var blockContextDeallocated: NSObject?

            var performBlockCount = 0

            let increasePerformBlockCount = { () -> Void in
                performBlockCount += 1
            }

            autoreleasepool {
                let blockContext: NSObject? = NSObject()
                blockContextDeallocated = blockContext

                strongHolder!.simpleBlock = {
                    if blockContext != nil && strongHolder != nil {
                        increasePerformBlockCount()
                    }
                }
                
                strongHolder!.onceSimpleBlock()()
                strongHolder!.onceSimpleBlock()()
            }

            XCTAssertTrue (blockContextDeallocated == nil, "Block context should be dealloced")
            XCTAssertEqual(1, performBlockCount   , "Block was called once")

            let block = strongHolder?.simpleBlock
            XCTAssertTrue(block == nil)
        }

        XCTAssertNil(weakHolder, "Block holder should be dealloced")
    }
}
