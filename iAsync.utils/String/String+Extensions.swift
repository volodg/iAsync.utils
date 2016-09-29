//
//  String+Extensions.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 29/09/16.
//  Copyright © 2016 EmbeddedSources. All rights reserved.
//

import Foundation

extension String {

    ///  Finds the string between two bookend strings if it can be found.
    ///
    ///  - parameter left:  The left bookend
    ///  - parameter right: The right bookend
    ///
    ///  - returns: The string between the two bookends, or nil if the bookends cannot be found, the bookends are the same or appear contiguously.
    public func between(left: String, _ right: String) -> String? {
        guard
            let leftRange = rangeOfString(left), let rightRange = rangeOfString(right, options: .BackwardsSearch)
            where left != right && leftRange.endIndex != rightRange.startIndex
            else { return nil }
        
        return self[leftRange.endIndex...rightRange.startIndex.predecessor()]
        
    }

    public func substring(startIndex: Int, length: Int) -> String {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self[start..<end]
    }

    public func contains(substring: String) -> Bool {
        return rangeOfString(substring) != nil
    }

    public func toDouble(locale: NSLocale = NSLocale.systemLocale()) -> Double? {
        let nf = NSNumberFormatter()
        nf.locale = locale
        if let number = nf.numberFromString(self) {
            return number.doubleValue
        }
        return nil
    }

    public func toInt() -> Int? {
        if let number = NSNumberFormatter().numberFromString(self) {
            return number.integerValue
        }
        return nil
    }

    public func trimmed() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}
