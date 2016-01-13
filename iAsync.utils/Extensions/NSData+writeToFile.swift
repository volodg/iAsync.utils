//
//  NSData+writeToFile.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 13.01.16.
//  Copyright (c) 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public extension NSData {

    func tmpFilePath(fileName: String = NSUUID().UUIDString) -> String {

        let filePath = String.cachesPathByAppendingPathComponent(fileName)

        writeToFile(filePath, atomically: true)

        return filePath
    }
}
