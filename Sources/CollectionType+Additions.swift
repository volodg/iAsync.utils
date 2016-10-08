//
//  CollectionType+Additions.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 12.08.15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import Foundation

extension Collection {

    public func any(_ predicate: (Self.Iterator.Element) -> Bool) -> Bool {

        let index = self.index(where: predicate)
        return index != nil
    }

    public func all(_ predicate: (Self.Iterator.Element) -> Bool) -> Bool {

        return !any { object -> Bool in
            return !predicate(object)
        }
    }

    public func foldr<B>(_ zero: B, f: @escaping (Iterator.Element, () -> B) -> B) -> B {

        var g = makeIterator()
        var next: (() -> B)! = {zero}

        next = { return g.next().map {x in f(x, next)} ?? zero }
        let result = next()
        next = nil
        return result
    }
}
