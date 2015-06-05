//
//  AssignObjectHolder.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 17.09.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public class AssignObjectHolder<T: AnyObject> {
    
    private(set) var target: Unmanaged<T>
    
    public init(targetPtr: Unmanaged<T>) {
        
        self.target = targetPtr
    }
}
