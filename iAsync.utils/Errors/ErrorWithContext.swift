//
//  ErrorWithContext.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 17/04/16.
//  Copyright (c) 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public struct ErrorWithContext : ErrorType {

    public let error  : NSError
    public let context: AnyObject

    public init(error: NSError, context: AnyObject) {

        self.error   = error
        self.context = context
    }

    public func writeErrorWithLogger() {
        error.writeErrorWithLogger(context)
    }
}
