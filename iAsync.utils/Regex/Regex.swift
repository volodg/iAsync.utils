//
//  Regex.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 17.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//
//  source: http://benscheirman.com/2014/06/regex-in-swift/

import Foundation

public class Regex {
    let internalExpression: NSRegularExpression!
    let pattern: String
    
    public init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    }
    
    public func test(input: String) -> Bool {
        
        return matches(input).count > 0
    }
    
    public func matches(input: String) -> [NSTextCheckingResult] {
        
        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches as! [NSTextCheckingResult]
    }
}

infix operator =~ {}

func =~ (input: String, pattern: String) -> Bool {
    return Regex(pattern).test(input)
}
