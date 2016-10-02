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
    internal let rawPtr: UnsafeMutableRawPointer

    public init(_ raw: T) {
        self.raw = raw
        self.rawPtr = Unmanaged.passUnretained(raw).toOpaque()
    }
}

public struct EquatableWeakBox<T: AnyObject> : Equatable where T: Equatable {
    public weak var raw: T?

    public init(_ raw: T) {
        self.raw = raw
    }
}

public func ==<T: AnyObject>(lhs: EquatableWeakBox<T>, rhs: EquatableWeakBox<T>) -> Bool where T: Equatable {

    return lhs.raw == rhs.raw
}
