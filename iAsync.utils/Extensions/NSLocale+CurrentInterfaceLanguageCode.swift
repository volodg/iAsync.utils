//
//  NSLocale+CurrentInterfaceLanguageCode.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension NSLocale {
    
    static var preferredISO2Languages: [String] {
        
        return self.preferredLanguages().map { $0.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "_-"))[0] }
    }
}
