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

//source - http://oleb.net/blog/2015/09/more-pattern-matching-examples/
public func flip<A, B, C>(method: A -> B -> C)(_ b: B)(_ a: A) -> C {
    return method(a)(b)
}

public func id<T>(val: T) -> T {
    return val
}
