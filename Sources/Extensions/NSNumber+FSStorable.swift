//
//  NSNumber+FSStorable.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

private func readStringWithScanner<T>(documentFile: String, scanner: (String) -> T?) -> T? {

    let path        = documentFile.documentsPath
    let filesString = path.stringContent()
    let result      = filesString.flatMap { scanner($0) }
    return result
}

public func writeObject<T>(_ object: T?, toDocumentFile documentFile: String, logError: Bool = true) -> Bool {

    let filePath = documentFile.documentsPath

    guard let object = object else {

        return filePath.removeItem(logError: logError)
    }

    let string = String(describing: object)

    let result = filePath.writeToFile(str: string)

    if result {
        filePath.addSkipBackupAttribute()
    }

    return result
}

public extension Int {

    public static func readFromFile(_ documentFile: String) -> Int? {

        let scanner = { (string: String) -> Int? in
            var scannedNumber = 0
            let scanner = Scanner(string: string)
            if scanner.scanInt(&scannedNumber) {
                return scannedNumber
            }
            return nil
        }

        return readStringWithScanner(documentFile: documentFile, scanner: scanner)
    }
}

public extension Double {

    public static func readFromFile(_ documentFile: String) -> Double? {

        let scanner = { (string: String) -> Double? in
            var scannedNumber = 0.0
            let scanner = Scanner(string: string)
            if scanner.scanDouble(&scannedNumber) {
                return scannedNumber
            }
            return nil
        }

        return readStringWithScanner(documentFile: documentFile, scanner: scanner)
    }
}

public extension String {

    public static func readFromFile(_ documentFile: String) -> String? {

        let scanner = { (string: String) -> String? in
            return string
        }

        return readStringWithScanner(documentFile: documentFile, scanner: scanner)
    }
}

public extension Bool {

    public static func readFromFile(_ documentFile: String) -> Bool? {

        return Int.readFromFile(documentFile).flatMap { $0 != 0 }
    }
}
