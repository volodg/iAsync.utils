//
//  Locale+CurrentInterfaceLanguageCode.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension Locale {

    static var preferredISO2Languages: [String] {

        let preferredLangs = preferredLanguages
        let characters     = CharacterSet(charactersIn: "_-")
        return preferredLangs.map { $0.components(separatedBy: characters)[0] }
    }
}
