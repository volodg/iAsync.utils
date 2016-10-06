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
        let result = (path as NSString).deletingLastPathComponent
        return result
    }

    public var fileName: String {
        let result = (path as NSString).lastPathComponent
        return result
    }

    public func stringContent() -> String? {

        do {
            let result = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            return result as String
        } catch _ {
            return nil
        }
    }

    public func dictionaryContent() -> NSDictionary? {

        let result = NSDictionary(contentsOfFile: path)
        return result
    }

    public func dataContent() -> Data? {

        let result = try? Data(contentsOf: URL(fileURLWithPath: path))
        return result
    }

    public func removeItem(_ logError: Bool = true) -> Bool {

        do {
            try FileManager.default.removeItem(atPath: path)
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

    func writeToFile(_ str: String) -> Bool {

        do {
            try str.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch _ {
            return false
        }
    }

    public func writeToFile(_ dict: NSDictionary) -> Bool {

        let result = dict.write(toFile: path, atomically: true)
        return result
    }

    public func writeToFile(_ data: Data) -> Bool {

        let result = (try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        return result
    }
}

public extension URL {

    func filePath() -> FilePath {

        struct FilePath_: FilePath {
            let path: String
        }

        assert(self.isFileURL)

        return FilePath_(path: self.path)
    }
}

public struct DocumentPath: FilePath {

    static var docDirectory = String.pathWithSearchDirecory(.documentDirectory)

    public let path: String

    fileprivate init(path: String) {

        assert(!path.hasPrefix(DocumentPath.docDirectory))

        let docPath = (DocumentPath.docDirectory as NSString).appendingPathComponent(path)

        self.path = docPath
    }
}

public extension String {

    fileprivate static func pathWithSearchDirecory(_ directory: FileManager.SearchPathDirectory) -> String {

        let pathes = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
        return pathes[pathes.endIndex - 1]
    }

    public var documentsPath: DocumentPath {

        return DocumentPath(path: self)
    }

    static func cachesPathByAppendingPathComponent(_ str: String?) -> String {

        struct Static {
            static var instance = String.pathWithSearchDirecory(.cachesDirectory)
        }

        guard let str = str else { return Static.instance }

        return (Static.instance as NSString).appendingPathComponent(str)
    }
}
