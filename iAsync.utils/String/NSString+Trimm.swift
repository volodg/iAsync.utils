//
//  String+Trimm.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 08.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension String {
    
    private func rangeForQuotesRemoval() -> Range<String.Index> {
        let start = advance(self.startIndex,  1)
        let end   = advance(self.endIndex  , -1)
        
        return start..<end
    }
    
    func stringByTrimmingQuotes() -> NSString {
        
        let rangeWithoutQuotes = rangeForQuotesRemoval()
        let result = substringWithRange(rangeWithoutQuotes)
        
        let termWhitespaces = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        return result.stringByTrimmingCharactersInSet(termWhitespaces)
    }
    
    func stringByTrimmingWhitespaces() -> String {
        
        let set = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        return stringByTrimmingCharactersInSet(set)
    }
    
    func stringByTrimmingPunctuation() -> String  {
        
        let set = NSCharacterSet.punctuationCharacterSet()
        return stringByTrimmingCharactersInSet(set)
    }
}
