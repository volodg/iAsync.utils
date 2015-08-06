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
    
    public init(_ value: T)
    {
        self.value = value
    }
}
