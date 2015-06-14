//
//  NSNumber+FSStorable.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

private func parseNumber<T>(documentFile documentFile: String, scanner: (String) -> T?) -> T? {
    
    let path = String.documentsPathByAppendingPathComponent(documentFile)
    
    do {
        let string = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return scanner(string as String)
    } catch _ {
        return nil
    }
}

public func writeObject<T>(object: T, toDocumentFile documentFile: String) -> Bool {
    
    let string = String(object)
    
    let fileName = String.documentsPathByAppendingPathComponent(documentFile)
    
    let result: Bool
    do {
        try string.writeToFile(
                fileName,
                atomically: true,
                encoding  : NSUTF8StringEncoding)
        result = true
    } catch _ {
        result = false
    }
    
    if result {
        fileName.addSkipBackupAttribute()
    }
    
    return result
}

public extension Int {
    
    public static func readFromFile(documentFile: String) -> Int? {
        
        let scanner = { (string: String) -> Int? in
            var scannedNumber: Int = 0
            let scanner = NSScanner(string: string)
            if scanner.scanInteger(&scannedNumber) {
                return scannedNumber
            }
            return nil
        }
        
        return parseNumber(documentFile: documentFile, scanner: scanner)
    }
}

public extension Double {
    
    public static func readFromFile(documentFile: String) -> Double? {
        
        let scanner = { (string: String) -> Double? in
            var scannedNumber: Double = 0
            let scanner = NSScanner(string: string)
            if scanner.scanDouble(&scannedNumber) {
                return scannedNumber
            }
            return nil
        }
        
        return parseNumber(documentFile: documentFile, scanner: scanner)
    }
}

public extension Bool {
    
    public static func readFromFile(documentFile: String) -> Bool? {
        
        if let result = Int.readFromFile(documentFile) {
            return result != 0
        }
        
        return nil
    }
}
