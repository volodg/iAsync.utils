//
//  String+PathExtensions.swift
//  iAsync_utils
//
//  Created by Vlafimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension String {

    private static func pathWithSearchDirecory(directory: NSSearchPathDirectory) -> String {

        let pathes = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)
        return pathes[pathes.endIndex - 1]
    }

    static func documentsPathByAppendingPathComponent(str: String?) -> String {

        struct Static {
            static var instance = String.pathWithSearchDirecory(.DocumentDirectory)
        }

        guard let str = str else { return Static.instance }

        return (Static.instance as NSString).stringByAppendingPathComponent(str)
    }

    static func cachesPathByAppendingPathComponent(str: String?) -> String {

        struct Static {
            static var instance = String.pathWithSearchDirecory(.CachesDirectory)
        }

        guard let str = str else { return Static.instance }

        return (Static.instance as NSString).stringByAppendingPathComponent(str)
    }
}
