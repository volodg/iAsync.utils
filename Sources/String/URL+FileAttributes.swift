//
//  URL+FileAttributes.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension URL {

    mutating func addSkipBackupAttribute() {

        assert(FileManager.default.fileExists(atPath: self.path))

        do {
            var vales = URLResourceValues()
            vales.isExcludedFromBackup = true
            try self.setResourceValues(vales)
        } catch let error as NSError {
            iAsync_utils_logger.logError("setResourceValue error: \(error) path: \(self)", context: #function)
        } catch _ {
            iAsync_utils_logger.logError("setResourceValue error to path: \(self)", context: #function)
        }
    }
}
