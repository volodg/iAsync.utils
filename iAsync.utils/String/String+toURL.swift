//
//  String+toURL.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 06.08.15.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

extension String {
    
    public func toURL() -> NSURL? {
        
        return NSURL(string: self)
    }
}
