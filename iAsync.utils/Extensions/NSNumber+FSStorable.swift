//
//  NSNumber+FSStorable.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

private func readStringWithScanner<T>(documentFile documentFile: String, @noescape scanner: (String) -> T?) -> T? {

    let path = String.documentsPathByAppendingPathComponent(documentFile)

    do {
        let string = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return scanner(string as String)
    } catch _ {
        return nil
    }
}

public func writeObject<T>(object: T?, toDocumentFile documentFile: String) -> Bool {

    let filePath = String.documentsPathByAppendingPathComponent(documentFile)

    guard let object = object else {

        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
            return true
        } catch let error as NSError {
            iAsync_utils_logger.logError("can not remove file error: \(error) filePath: \(filePath)", context: #function)
            return false
        } catch _ {
            iAsync_utils_logger.logError("can not remove file: \(filePath)", context: #function)
            return false
        }
    }

    let string = String(object)

    let result: Bool
    do {
        try string.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        result = true
    } catch _ {
        result = false
    }

    if result {
        filePath.addSkipBackupAttribute()
    }

    return result
}

public extension Int {

    public static func readFromFile(documentFile: String) -> Int? {

        let scanner = { (string: String) -> Int? in
            var scannedNumber = 0
            let scanner = NSScanner(string: string)
            if scanner.scanInteger(&scannedNumber) {
                return scannedNumber
            }
            return nil
        }

        return readStringWithScanner(documentFile: documentFile, scanner: scanner)
    }
}

public extension Double {

    public static func readFromFile(documentFile: String) -> Double? {

        let scanner = { (string: String) -> Double? in
            var scannedNumber = 0.0
            let scanner = NSScanner(string: string)
            if scanner.scanDouble(&scannedNumber) {
                return scannedNumber
            }
            return nil
        }

        return readStringWithScanner(documentFile: documentFile, scanner: scanner)
    }
}

public extension String {

    public static func readFromFile(documentFile: String) -> String? {

        let scanner = { (string: String) -> String? in
            return string
        }

        return readStringWithScanner(documentFile: documentFile, scanner: scanner)
    }
}

public extension Bool {

    public static func readFromFile(documentFile: String) -> Bool? {

        return Int.readFromFile(documentFile).flatMap { $0 != 0 }
    }
}
