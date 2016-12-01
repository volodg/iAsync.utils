//
//  JSchedulerTest.swift
//  JAsyncTests
//
//  Created by Vladimir Gorbenko on 26.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import XCTest

import iAsync_utils

class JSchedulerTest: XCTestCase {

    func testCancelWhenDeallocedScheduler() {

        let sharedTimer = Timer.sharedByThreadTimer()

        var fired = false
        var timeDifference = 0.0

        let setTimeDifference = { (difference: Double) -> () in

            timeDifference = difference;
        }

        weak var weakTimer: iAsync_utils.Timer?

        autoreleasepool {

            let timer = Timer()
            weakTimer = timer

            _ = timer.add(actionBlock: { cancel in

                cancel()
                fired = true
            }, delay: .milliseconds(10))

            let startDate = Date()

            let expectation = self.expectation(description: "")

            _ = sharedTimer.add(actionBlock: { cancel in

                let finishDate = Date()
                setTimeDifference(finishDate.timeIntervalSince(startDate))

                cancel()
                expectation.fulfill()
            }, delay: .milliseconds(20))
        }

        self.waitForExpectations(timeout: 1, handler: nil)

        XCTAssertNil(weakTimer)
        XCTAssertFalse(fired)
        XCTAssertTrue(timeDifference >= 0.02)
    }

    func testCancelBlockReturned() {

        weak var weakTimer: iAsync_utils.Timer?

        autoreleasepool {

            let sharedScheduler = Timer.sharedByThreadTimer()

            var fired = false
            var timeDifference = 0.0

            let timer = Timer()
            weakTimer = timer

            let mainCancel = timer.add(actionBlock: { cancel in
                cancel()
                fired = true
            }, delay: .milliseconds(20))

            _ = sharedScheduler.add(actionBlock: { cancel in
                mainCancel()
                cancel()
            }, delay: .milliseconds(10))

            let startDate = Date()

            let expectation = self.expectation(description: "")

            _ = sharedScheduler.add(actionBlock: { cancel in

                let finishDate = NSDate()
                timeDifference = finishDate.timeIntervalSince(startDate)

                cancel()
                expectation.fulfill()
            }, delay: .milliseconds(30))

            self.waitForExpectations(timeout: 1, handler: nil)

            XCTAssertFalse(fired)
            XCTAssertTrue(timeDifference >= 0.028)
        }

        XCTAssertNil(weakTimer)
    }

    func testCancelAllScheduledOperations() {

        weak var weakTimer: iAsync_utils.Timer?

        autoreleasepool {

            var fired = false
            var timeDifference = 0.0

            let sharedScheduler = iAsync_utils.Timer.sharedByThreadTimer()

            let timer = Timer()
            weakTimer = timer

            _ = timer.add(actionBlock: { cancel in

                cancel()
                fired = true
            }, delay: .milliseconds(90))

            _ = timer.add(actionBlock: { cancel in

                cancel()
                fired = true
            }, delay: .milliseconds(90))

            _ = sharedScheduler.add(actionBlock: { cancel in

                timer.cancelAllScheduledOperations()
                cancel()
            }, delay: .milliseconds(1))

            let startDate = Date()

            let expectation = self.expectation(description: "")

            _ = sharedScheduler.add(actionBlock: { cancel in

                let finishDate = NSDate()
                timeDifference = finishDate.timeIntervalSince(startDate)

                cancel()
                expectation.fulfill()
            }, delay: .milliseconds(10))

            self.waitForExpectations(timeout: 1, handler: nil)

            XCTAssertFalse(fired)
            XCTAssertTrue(timeDifference >= 0.01)
        }

        XCTAssertNil(weakTimer)
    }

    func testNormalScheduledOperationTwice() {

        let sharedScheduler = Timer.sharedByThreadTimer()

        var timeDifference = 0.0

        let startDate = Date()

        let expectation = self.expectation(description: "")

        var fired = false
        _ = sharedScheduler.add(actionBlock: { cancel in

            if fired {

                let finishDate = NSDate()
                timeDifference = finishDate.timeIntervalSince(startDate)

                cancel()
                expectation.fulfill()
            }

            fired = true
        }, delay: .milliseconds(20))

        self.waitForExpectations(timeout: 1, handler: nil)

        XCTAssertTrue(timeDifference >= 0.02)
    }
}
