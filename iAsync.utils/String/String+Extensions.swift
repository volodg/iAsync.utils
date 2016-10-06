//
//  String+Extensions.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 29/09/16.
//  Copyright © 2016 EmbeddedSources. All rights reserved.
//

import Foundation

//source - SwiftString

extension String {

    ///  Finds the string between two bookend strings if it can be found.
    ///
    ///  - parameter left:  The left bookend
    ///  - parameter right: The right bookend
    ///
    ///  - returns: The string between the two bookends, or nil if the bookends cannot be found, the bookends are the same or appear contiguously.
    public func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , left != right && leftRange.upperBound != rightRange.lowerBound
            else { return nil }

        return self[leftRange.upperBound...self.index(before: rightRange.lowerBound)]
    }

    public func substring(_ startIndex: Int, length: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self[start..<end]
    }

    public func toDouble(_ locale: Locale = Locale.current) -> Double? {
        let nf = NumberFormatter()
        nf.locale = locale
        if let number = nf.number(from: self) {
            return number.doubleValue
        }
        return nil
    }

    public func toInt() -> Int? {
        if let number = NumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }

    public func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    public subscript(r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return self[startIndex..<endIndex]
        }
    }
}
