//
//  Helpers.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 11.08.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public func synced<R>(lock: AnyObject, @noescape _ closure: () -> R) -> R {
    objc_sync_enter(lock)
    let result = closure()
    objc_sync_exit(lock)
    return result
}

public func foldr<A : SequenceType, B>(xs: A, zero: B, f: (A.Generator.Element, () -> B) -> B) -> B {
    var g = xs.generate()
    var next: () -> B = {zero}
    next = { return g.next().map {x in f(x, next)} ?? zero }
    return next()
}
