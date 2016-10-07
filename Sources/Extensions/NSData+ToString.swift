//
//  NSData+ToString.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

extension Data {

    public func toString() -> String? {

        let bytesPointer = self.withUnsafeBytes { bytes in
            return UnsafePointer<CChar>(bytes)
        }
        return String(validatingUTF8: bytesPointer)
    }

    func hexString() -> String {

        let bytesPointer = self.withUnsafeBytes { bytes in
            return UnsafeBufferPointer<UInt8>(start: UnsafePointer(bytes), count: self.count)
        }
        let hexBytes = bytesPointer.map { return String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }

    public func apnsToString() -> String {

        let result = hexString()
        return result
    }
}
