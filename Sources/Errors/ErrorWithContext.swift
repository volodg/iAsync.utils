//
//  ErrorWithContext.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 17/04/16.
//  Copyright © 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public struct ErrorWithContext : Swift.Error {

    public let error  : UtilsError
    public let context: String

    public init(error: UtilsError, context: String) {

        self.error   = error
        self.context = context
    }

    public init(error: Error, context: String) {

        self.error   = WrapperOfNSError(forError: error)
        self.context = context
    }
}
