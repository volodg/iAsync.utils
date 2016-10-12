//
//  Data+ToString.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

extension Data {

    public func toString() -> String? {

        return withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in

            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
            buffer.assign(from: bytes, count: count)
            let result = String(bytesNoCopy: buffer, length: count, encoding: .utf8, freeWhenDone: true)
            return result
        }
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
