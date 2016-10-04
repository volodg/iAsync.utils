//
//  HashableArray.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 02.10.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public struct HashableArray<T: Equatable> : Hashable, Collection/*, MutableCollectionType*/, CustomStringConvertible, ExpressibleByArrayLiteral {
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return array.index(after: i)
    }

    public var array: Array<T>

//    typealias SubSequence = MutableSlice<Self>
//    public subscript (position: Self.Index) -> Self.Generator.Element { get set }
//    public subscript (bounds: Range<Self.Index>) -> Self.SubSequence { get set }

    public var last: T? {
        return array.last
    }

    public typealias Iterator = Array<T>.Iterator

    public typealias Index = Array<T>.Index
    //    public typealias Generator = Array<T>.Generator
    public typealias Element = Array<T>.Element
    public typealias _Element = Array<T>._Element

    public var startIndex: Index { return array.startIndex }
    public var endIndex: Index { return array.endIndex }

    public subscript (position: Index) -> _Element {
        return array[position]
    }

    public func makeIterator() -> Iterator {

        return array.makeIterator()
    }

    public mutating func removeAll() {
        array.removeAll()
    }

    public mutating func append(_ el: T) {
        array.append(el)
    }

    public var hashValue: Int {
        return array.count
    }

    public init(_ array: [T]) {

        self.array = array
    }

    public init(arrayLiteral elements: Element...) {
        self.init(Array(elements))
    }

    public init() {

        self.init([])
    }

    public var description: String {
        return "iAsync.utils.HashableArray: \(array)"
    }
}

public func ==<T: Equatable>(lhs: HashableArray<T>, rhs: HashableArray<T>) -> Bool {

    return lhs.array == rhs.array
}
