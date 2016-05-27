//
//  WeakBox.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 06.08.15.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public struct WeakBox<T: AnyObject> {
    public weak var raw: T?

    public init(_ raw: T?) {
        self.raw = raw
    }
}

public struct EquatableWeakBox<T: AnyObject where T: Equatable> : Equatable {
    public weak var raw: T?

    public init(_ raw: T) {
        self.raw = raw
    }
}

public func ==<T: AnyObject where T: Equatable>(lhs: EquatableWeakBox<T>, rhs: EquatableWeakBox<T>) -> Bool {

    return lhs.raw == rhs.raw
}
