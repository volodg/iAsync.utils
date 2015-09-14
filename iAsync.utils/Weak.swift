//
//  Weak.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 06.08.15.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public struct Weak<T: AnyObject> {
    public weak var value: T?
    
    public init(_ value: T?)
    {
        self.value = value
    }
}

public struct EquatableWeak<T: AnyObject where T: Equatable> : Equatable {
    public weak var value: T?
    
    public init(_ value: T)
    {
        self.value = value
    }
}

public func ==<T: AnyObject where T: Equatable>(lhs: EquatableWeak<T>, rhs: EquatableWeak<T>) -> Bool {

    return lhs.value == rhs.value
}
