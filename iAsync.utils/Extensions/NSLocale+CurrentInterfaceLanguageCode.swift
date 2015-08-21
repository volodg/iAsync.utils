//
//  NSLocale+CurrentInterfaceLanguageCode.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension NSLocale {
    
    class var currentInterfaceLanguageCode: String {
        
        let languageCodes = self.preferredLanguages() as [String]
        let languageCode = languageCodes[0]
        return languageCode
    }
    
    class var currentInterfaceISO2LanguageCode: String {
        
        let languageCode = self.currentInterfaceLanguageCode
        //TODO vlg, its woraround for IOS9, should be "_" character only
        return languageCode.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "_-"))[0]
    }
}
