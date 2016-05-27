//
//  CollectionType+Additions.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 12.08.15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import Foundation

extension CollectionType {

    public func any(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {

        let index = indexOf(predicate)
        return index != nil
    }

    public func all(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {

        return !any { (object: Generator.Element) -> Bool in
            return !predicate(object)
        }
    }

    public func foldr<B>(zero: B, f: (Generator.Element, () -> B) -> B) -> B {

        var g = generate()
        var next: (() -> B)! = {zero}

        next = { return g.next().map {x in f(x, next)} ?? zero }
        let result = next()
        next = nil
        return result
    }
}
