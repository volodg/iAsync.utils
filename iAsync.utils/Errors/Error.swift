//
//  Error.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 05.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public class Error : NSError {
    
    //TODO it make protected, TODO rename
    public class func jffErrorsDomain() -> String {
        return "com.just_for_fun.library"
    }
    
    public init(description: String, domain: String = Error.jffErrorsDomain(), code: Int = 0) {
        
        let userInfo = [NSLocalizedDescriptionKey : description]
        super.init(domain: domain, code: code, userInfo: userInfo)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}