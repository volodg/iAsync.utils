//
//  String+PathExtensions.swift
//  iAsync_utils
//
//  Created by Vlafimir Gorbenko on 06.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
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
        
        if let str = str {
            return (Static.instance as NSString).stringByAppendingPathComponent(str)
        }
        
        return Static.instance
    }
    
    static func cachesPathByAppendingPathComponent(str: String?) -> String {
        
        struct Static {
            static var instance = String.pathWithSearchDirecory(.CachesDirectory)
        }
        
        if let str = str {
            return (Static.instance as NSString).stringByAppendingPathComponent(str)
        }
        
        return Static.instance as String
    }
}
