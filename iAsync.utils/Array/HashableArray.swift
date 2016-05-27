//
//  HashableArray.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 02.10.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public struct HashableArray<T: Equatable> : Hashable, CollectionType/*, MutableCollectionType*/, CustomStringConvertible, ArrayLiteralConvertible {

    public var array: Array<T>

//    typealias SubSequence = MutableSlice<Self>
//    public subscript (position: Self.Index) -> Self.Generator.Element { get set }
//    public subscript (bounds: Range<Self.Index>) -> Self.SubSequence { get set }

    public typealias Generator = Array<T>.Generator

    public typealias Index = Array<T>.Index
    //    public typealias Generator = Array<T>.Generator
    public typealias Element = Array<T>.Element
    public typealias _Element = Array<T>._Element

    public var startIndex: Index { return array.startIndex }
    public var endIndex: Index { return array.endIndex }

    public subscript (position: Index) -> _Element {
        return array[position]
    }

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
