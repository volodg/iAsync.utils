//
//  JContainersHelperBlocks.swift
//  JUtils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

import Box

public enum Result<V> {
    case Error(NSError)
    case Value(Box<V>)
    
    public static func error(e: NSError) -> Result<V> {
        return .Error(e)
    }
    
    public static func value(v: V) -> Result<V> {
        return .Value(Box(v))
    }
    
    public func onError(handler: (NSError) -> Void) {
        switch self {
        case let .Error(error):
            handler(error)
        default:
            break
        }
    }
    
    public func onValue(handler: (V) -> Void) {
        switch self {
        case let .Value(v):
            handler(v.value)
        default:
            break
        }
    }
}

public func >>=<VA, VB>(a: Result<VA>, f: VA -> Result<VB>) -> Result<VB> {
    switch a {
    case let .Error(l): return .Error(l)
    case let .Value(r): return f(r.value)
    }
}
