//
//  String+PathExtensions.swift
//  iAsync_utils
//
//  Created by Vlafimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

//todo remove
public protocol FilePath {

    var filePath: URL { get }
    var folder: URL { get }
}

extension FilePath {

    public var folder: URL {
        let result = filePath.deletingLastPathComponent()
        return result
    }

    public var fileName: String {
        let result = filePath.lastPathComponent
        return result
    }

    public func stringContent() -> String? {

        let data   = dataContent()
        let result = data?.toString()
        return result
    }

    public func dictionaryContent() -> NSDictionary? {

        let result = NSDictionary(contentsOf: filePath)
        return result
    }

    public func dataContent() -> Data? {

        let result = try? Data(contentsOf: filePath)
        return result
    }

    public func removeItem(logError: Bool = true) -> Bool {

        do {
            try FileManager.default.removeItem(at: filePath)
            return true
        } catch let error as NSError {
            if logError {
                iAsync_utils_logger.logError("can not remove file error: \(error) filePath: \(filePath)", context: #function)
            }
            return false
        } catch _ {
            if logError {
                iAsync_utils_logger.logError("can not remove file: \(filePath)", context: #function)
            }
            return false
        }
    }

    public func addSkipBackupAttribute() {

        var filePath_ = filePath
        filePath_.addSkipBackupAttribute()
    }

    func writeToFile(str: String) -> Bool {

        do {
            try str.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch _ {
            return false
        }
    }

    public func writeToFile(dict: NSDictionary) -> Bool {

        let result = dict.write(to: filePath, atomically: true)
        return result
    }

    public func writeToFile(data: Data) -> Bool {

        let result = (try? data.write(to: filePath, options: [.atomic])) != nil
        return result
    }
}

public extension URL {

    func filePath() -> FilePath {

        struct FilePath_: FilePath {
            var filePath: URL
        }

        assert(self.isFileURL)

        return FilePath_(filePath: self)
    }
}

public struct DocumentPath: FilePath {

    static var docDirectory = URL.pathWith(searchDirecory: .documentDirectory)

    public let filePath: URL

    fileprivate init(path: String) {

        assert(!path.hasPrefix(DocumentPath.docDirectory.path))

        let docPath = DocumentPath.docDirectory.appendingPathComponent(path)

        self.filePath = docPath
    }
}

public extension URL {

    fileprivate static func pathWith(searchDirecory: FileManager.SearchPathDirectory) -> URL {

        let pathes = FileManager.default.urls(for: searchDirecory, in: .userDomainMask)
        return pathes.last!
    }

    static func cachesPathByAppending(pathComponent: String?) -> URL {

        struct Static {
            static var instance = URL.pathWith(searchDirecory: .cachesDirectory)
        }

        guard let str = pathComponent else { return Static.instance }

        return Static.instance.appendingPathComponent(str)
    }
}

public extension String {

    public var documentsPath: DocumentPath {

        return DocumentPath(path: self)
    }
}
