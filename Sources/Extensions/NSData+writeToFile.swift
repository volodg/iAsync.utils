//
//  NSData+writeToFile.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 13.01.16.
//  Copyright © 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public extension Data {

    func tmpFilePath(_ fileName: String = UUID().uuidString) -> String {

        let filePath = String.cachesPathByAppending(pathComponent: fileName)

        let url = URL(fileURLWithPath: filePath)
        try? write(to: url, options: [])//todo log error

        return filePath
    }
}
