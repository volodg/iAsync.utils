//
//  JMutableAssignDictionaryTest.swift
//  JUtilsTests
//
//  Created by Vladimir Gorbenko on 15.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import XCTest

import iAsync_utils

class MutableAssignDictionaryTest: XCTestCase {

    func testMutableAssignDictionaryAssignIssue() {

        var dict1: WeakRefMap<String, NSObject>?
        var dict2: WeakRefMap<String, NSObject>?

        weak var targetDeallocated: NSObject?;

        autoreleasepool {
            let target = NSObject()
            targetDeallocated = target

            dict1 = WeakRefMap<String, NSObject>()
            dict1!["1"] = target

            dict2 = WeakRefMap<String, NSObject>()
            dict2!["1"] = target
            dict2!["2"] = target

            XCTAssertEqual(1, dict1!.count, "Contains 1 object")
            XCTAssertEqual(2, dict2!.count, "Contains 2 objects")
        }

        XCTAssertTrue(targetDeallocated == nil, "Target should be deallocated")
        XCTAssertEqual(0, dict1!.count, "Empty array")
        XCTAssertEqual(0, dict2!.count, "Empty array")
    }

    func testMutableAssignDictionaryFirstRelease() {

        let target = NSObject()

        weak var weakDict1: WeakRefMap<String, NSObject>?
        weak var weakDict2: WeakRefMap<String, NSObject>?

        autoreleasepool {
            let dict1 = WeakRefMap<String, NSObject>()
            weakDict1 = dict1

            dict1["1"] = target

            let dict2 = WeakRefMap<String, NSObject>()
            weakDict2 = dict2

            dict2["2"] = target
        }

        XCTAssertTrue(weakDict1 == nil, "Target should be dealloced")
        XCTAssertTrue(weakDict2 == nil, "Target should be dealloced")
    }

    func testObjectForKey() {

        let dict = WeakRefMap<String, NSObject>()

        weak var targetDeallocated_: NSObject?

        autoreleasepool {
            let object1 = NSObject()
            targetDeallocated_ = object1
            let object2 = NSObject()

            dict["1"] = object1
            dict["2"] = object2

            XCTAssertEqual(dict["1"]!, object1, "Dict contains object_")
            XCTAssertEqual(dict["2"]!, object2, "Dict contains object_")
            XCTAssertNil(dict["3"], "Dict no contains object for key \"2\"")

            var count = 0

            for (key, value) in dict.mapping {

                switch key {
                case "1":
                    XCTAssertEqual(value.raw, object1)
                    count += 1
                case "2":
                    XCTAssertEqual(value.raw, object2)
                    count += 1
                default:
                    XCTFail("should not be reached")
                }
            }

            XCTAssertEqual(count, 2, "Dict no contains object for key \"2\"")
        }

        XCTAssertTrue(targetDeallocated_ == nil, "Target should be dealloced")
        XCTAssertEqual(0, dict.count, "Empty dict")
    }

    func testReplaceObjectInDict() {

        let dict = WeakRefMap<String, NSObject>()

        autoreleasepool {

            weak var replacedObjectDeallocated: NSObject?

            var object: NSObject?

            autoreleasepool {
                let replacedObject = NSObject()
                replacedObjectDeallocated = replacedObject

                object = NSObject()

                dict["1"] = replacedObject

                XCTAssertEqual(dict["1"]!, replacedObject, "Dict contains object_")
                XCTAssertNil(dict["2"], "Dict no contains object for key \"2\"")

                dict["1"] = object!
                XCTAssertEqual(dict["1"]!, object!, "Dict contains object_")
            }

            XCTAssertTrue(replacedObjectDeallocated == nil)

            let currentObject = dict["1"]
            XCTAssertEqual(currentObject, object!)
        }

        XCTAssertTrue(0 == dict.count, "Empty dict")
    }

    func testEnumerateKeysAndObjectsUsingBlock() {

        let patternDict = [
            "1" : 1,
            "2" : 2,
            "3" : 3,
        ]

        let dict = WeakRefMap<String, NSObject>()

        for (key, val) in patternDict {
            dict[key] = val
        }

        var count = 0
        let resultDict = NSMutableDictionary()

        for (key, obj) in dict.mapping {

            count += 1
            resultDict.setObject(obj.raw!, forKey: key)
            let value: NSNumber! = patternDict[key]
            XCTAssertEqual(value, obj.raw)
        }

        XCTAssertEqual(count, 3)
        XCTAssertEqual(resultDict, patternDict)

        count = 0

        for (_, _) in dict.mapping {

            count += 1
            if count == 2 {
                break
            }
        }

        XCTAssertEqual(count, 2)
    }
}
