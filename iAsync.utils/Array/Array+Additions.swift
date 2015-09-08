//
//  Array+Additions.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 08.09.15.
//  Copyright (c) 2015 EmbeddedSources. All rights reserved.
//

import Foundation

extension Array {
    
    func forEach(@noescape body: (Array.Element) -> ()) {
        
        for el in self {
            body(el)
        }
    }
}
