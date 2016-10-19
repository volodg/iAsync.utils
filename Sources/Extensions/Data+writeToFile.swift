//
//  Data+writeToFile.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 13.01.16.
//  Copyright © 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public extension Data {

    func tmpFilePath(withFileName fileName: String = UUID().uuidString) -> URL {

        let url = URL.cachesPathByAppending(pathComponent: fileName)

        try? write(to: url, options: [])//todo log error

        return url
    }
}
