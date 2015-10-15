//
//  String+LocalizedPrice.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 09.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension String {
    
    static func localizedPrice(price: NSNumber, priceLocale: NSLocale) -> NSString {
        
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.formatterBehavior = .Behavior10_4
        numberFormatter.numberStyle       = .CurrencyStyle
        numberFormatter.locale            = priceLocale
        
        let result = numberFormatter.stringFromNumber(price)
        return result!
    }
}
