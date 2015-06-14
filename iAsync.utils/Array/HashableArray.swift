//
//  HashableArray.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 02.10.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public struct HashableArray<T: Equatable> : Hashable, SequenceType, CustomStringConvertible {
    
    internal var array: Array<T>
    
    typealias Generator = Array<T>.Generator
    
    public func generate() -> Generator {
        
        return array.generate()
    }

    public mutating func removeAll() {
        array.removeAll()
    }
    
    public mutating func append(el: T) {
        array.append(el)
    }
    
    public var hashValue: Int {
        return array.count
    }
    
    public init(array: [T]) {
        
        self.array = array
    }
    
    public init() {
        
        self.init(array: [T]())
    }
    
    public var description: String {
        return "iAsync.utils.HashableArray: \(array)"
    }
}

public func ==<T: Equatable>(lhs: HashableArray<T>, rhs: HashableArray<T>) -> Bool {
    
    return lhs.array == rhs.array
}
