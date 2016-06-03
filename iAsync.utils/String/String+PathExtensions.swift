//
//  String+PathExtensions.swift
//  iAsync_utils
//
//  Created by Vlafimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public protocol FilePath {

    var path: String { get }
    var folder: String { get }
}

extension FilePath {

    public var folder: String {
        let result = (path as NSString).stringByDeletingLastPathComponent
        return result
    }

    public var fileName: String {
        let result = (path as NSString).lastPathComponent
        return result
    }

    public func stringContent() -> String? {

        do {
            let result = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            return result as String
        } catch _ {
            return nil
        }
    }

    public func dictionaryContent() -> NSDictionary? {

        let result = try NSDictionary(contentsOfFile: path)
        return result
    }

    public func dataContent() -> NSData? {

        let result = try NSData(contentsOfFile: path)
        return result
    }

    public func removeItem(logError: Bool = true) -> Bool {

        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
            return true
        } catch let error as NSError {
            if logError {
                iAsync_utils_logger.logError("can not remove file error: \(error) filePath: \(path)", context: #function)
            }
            return false
        } catch _ {
            if logError {
                iAsync_utils_logger.logError("can not remove file: \(path)", context: #function)
            }
            return false
        }
    }

    public func addSkipBackupAttribute() {

        path.addSkipBackupAttribute()
    }

    func writeToFile(str: String) -> Bool {

        do {
            try str.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            return true
        } catch _ {
            return false
        }
    }

    public func writeToFile(dict: NSDictionary) -> Bool {

        let result = dict.writeToFile(path, atomically: true)
        return result
    }

    public func writeToFile(data: NSData) -> Bool {

        let result = data.writeToFile(path, atomically: true)
        return result
    }
}

public extension NSURL {

    func filePath() -> FilePath {

        struct FilePath_: FilePath {
            let path: String
        }

        assert(self.fileURL)

        return FilePath_(path: self.path!)
    }
}

public struct DocumentPath: FilePath {

    static var docDirectory = String.pathWithSearchDirecory(.DocumentDirectory)

    public let path: String

    private init(path: String) {

        assert(!path.hasPrefix(DocumentPath.docDirectory))

        let docPath = (DocumentPath.docDirectory as NSString).stringByAppendingPathComponent(path)

        self.path = docPath
    }
}

public extension String {

    private static func pathWithSearchDirecory(directory: NSSearchPathDirectory) -> String {

        let pathes = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)
        return pathes[pathes.endIndex - 1]
    }

    public var documentsPath: DocumentPath {

        return DocumentPath(path: self)
    }

    static func cachesPathByAppendingPathComponent(str: String?) -> String {

        struct Static {
            static var instance = String.pathWithSearchDirecory(.CachesDirectory)
        }

        guard let str = str else { return Static.instance }

        return (Static.instance as NSString).stringByAppendingPathComponent(str)
    }
}
