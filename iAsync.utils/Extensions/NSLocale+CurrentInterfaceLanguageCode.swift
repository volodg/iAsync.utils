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

        let preferredLangs = preferredLanguages()
        let characters     = NSCharacterSet(charactersInString: "_-")
        return preferredLangs.map { $0.componentsSeparatedByCharactersInSet(characters)[0] }
    }
}
