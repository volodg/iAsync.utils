//
//  String+toURL.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 22.10.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

extension String {
    
    func toURL() -> NSURL? {
        
        return NSURL(string: self)
    }
}
