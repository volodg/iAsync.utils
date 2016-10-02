//
//  NSData+ToString.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension Data {

    func toString() -> String? {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) as? String
    }

    func apnsToString() -> String {

        let result = self.description
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: " ", with: "")
        return result
    }
}
