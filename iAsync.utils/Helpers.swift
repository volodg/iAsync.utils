//
//  Helpers.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 11.08.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public func synced<R>(lock: AnyObject, @noescape _ closure: () -> R) -> R {
    objc_sync_enter(lock)
    let result = closure()
    objc_sync_exit(lock)
    return result
}

//source - http://oleb.net/blog/2015/09/more-pattern-matching-examples/
public func flip<A, B, C>(method: A -> B -> C) -> (B) -> (A) -> C {
    return { (b: B) -> A -> C in
        return { (a: A) -> C in
            method(a)(b)
        }
    }
}

public func id_<T>(val: T) -> T {
    return val
}
