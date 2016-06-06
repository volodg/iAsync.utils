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

        weak var weakTimer: Timer?

        autoreleasepool {

            let timer = Timer()
            weakTimer = timer

            _ = timer.addBlock({ (cancel: JCancelScheduledBlock) -> () in

                cancel()
                fired = true
            }, duration:0.01, leeway:0)

            let startDate = NSDate()

            let expectation = self.expectationWithDescription("")

            _ = sharedTimer.addBlock({ (cancel: JCancelScheduledBlock) -> () in

                let finishDate = NSDate()
                setTimeDifference(finishDate.timeIntervalSinceDate(startDate))

                cancel()
                expectation.fulfill()
            }, duration:0.02, leeway:0)
        }

        self.waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertNil(weakTimer)
        XCTAssertFalse(fired)
        XCTAssertTrue(timeDifference >= 0.02)
    }

    func testCancelBlockReturned() {

        weak var weakTimer: Timer?

        autoreleasepool {

            let sharedScheduler = Timer.sharedByThreadTimer()

            var fired = false
            var timeDifference = 0.0

            let timer = Timer()
            weakTimer = timer

            let mainCancel = timer.addBlock({ (cancel: JCancelScheduledBlock) -> () in
                cancel()
                fired = true
            }, duration:0.02)

            _ = sharedScheduler.addBlock({ (cancel: JCancelScheduledBlock) -> () in
                mainCancel()
                cancel()
            }, duration:0.01)

            let startDate = NSDate()

            let expectation = self.expectationWithDescription("")

            _ = sharedScheduler.addBlock({ (cancel: JCancelScheduledBlock) -> () in

                let finishDate = NSDate()
                timeDifference = finishDate.timeIntervalSinceDate(startDate)

                cancel()
                expectation.fulfill()
            }, duration:0.03)

            self.waitForExpectationsWithTimeout(1, handler: nil)

            XCTAssertFalse(fired)
            XCTAssertTrue(timeDifference >= 0.028)
        }

        XCTAssertNil(weakTimer)
    }

    func testCancelAllScheduledOperations() {

        weak var weakTimer: Timer?

        autoreleasepool {

            var fired = false
            var timeDifference = 0.0

            let sharedScheduler = Timer.sharedByThreadTimer()

            let timer = Timer()
            weakTimer = timer

            _ = timer.addBlock({ (cancel: JCancelScheduledBlock) -> () in

                cancel()
                fired = true
            }, duration:0.09, leeway:0.0)

            _ = timer.addBlock({ (cancel: JCancelScheduledBlock) -> () in

                cancel()
                fired = true
            }, duration:0.09, leeway:0.0)

            _ = sharedScheduler.addBlock({ (cancel: JCancelScheduledBlock) -> () in

                timer.cancelAllScheduledOperations()
                cancel()
            }, duration:0.001, leeway:0.0)

            let startDate = NSDate()

            let expectation = self.expectationWithDescription("")

            _ = sharedScheduler.addBlock({ (cancel: JCancelScheduledBlock) -> () in

                let finishDate = NSDate()
                timeDifference = finishDate.timeIntervalSinceDate(startDate)

                cancel()
                expectation.fulfill()
            }, duration:0.01, leeway:0.0)

            self.waitForExpectationsWithTimeout(1, handler: nil)

            XCTAssertFalse(fired)
            XCTAssertTrue(timeDifference >= 0.01)
        }

        XCTAssertNil(weakTimer)
    }

    func testNormalScheduledOperationTwice() {

        let sharedScheduler = Timer.sharedByThreadTimer()

        var timeDifference = 0.0

        let startDate = NSDate()

        let expectation = self.expectationWithDescription("")

        var fired = false
        _ = sharedScheduler.addBlock({ (cancel: JCancelScheduledBlock) -> () in

            if fired {

                let finishDate = NSDate()
                timeDifference = finishDate.timeIntervalSinceDate(startDate)

                cancel()
                expectation.fulfill()
            }

            fired = true
        }, duration:0.02)

        self.waitForExpectationsWithTimeout(1, handler: nil)

        XCTAssertTrue(timeDifference >= 0.02)
    }
}
