//
//  SilentError.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 05.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

open class SilentError : UtilsError {

    open override var logTarget: LogTarget {
        return LogTarget.console
    }
}
