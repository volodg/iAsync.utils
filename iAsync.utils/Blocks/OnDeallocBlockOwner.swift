//
//  OnDeallocBlockOwner.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 11.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

//TODO remove inheritence from -> NSObject
//TODO should be internal
public class OnDeallocBlockOwner : NSObject {
    
    public var block: SimpleBlock?
    
    public init(block: SimpleBlock) {
        
        self.block = block
    }
    
    deinit {
        if let value = self.block {
            self.block = nil
            value()
        }
    }
}
