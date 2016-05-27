//
//  HashableDictionary.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 02.10.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public struct HashableDictionary<Key : Hashable, Value: Equatable> : Hashable, CustomStringConvertible {

    public private(set) var dict = [Key:Value]()

    public var hashValue: Int {
        return dict.count
    }

    public init(_ dict: [Key:Value]) {

        self.dict = dict
    }

    public init() {

        self.init([Key:Value]())
    }

    public var description: String {
        return "JUtils.HashableDictionary: \(dict)"
    }
}

public func ==<Key : Hashable, Value: Equatable>(lhs: HashableDictionary<Key, Value>, rhs: HashableDictionary<Key, Value>) -> Bool {

    return lhs.dict == rhs.dict
}
