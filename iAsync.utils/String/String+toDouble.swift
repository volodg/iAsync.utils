//
//  String+toDouble.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 20.10.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension String {
    
    func toDouble(decimalSeparator: String = ".") -> Double? {
        
        let numFormatter = NSNumberFormatter()
        numFormatter.decimalSeparator = decimalSeparator
        return numFormatter.numberFromString(self)?.doubleValue
    }
}
