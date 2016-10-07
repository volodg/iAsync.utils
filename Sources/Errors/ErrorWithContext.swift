//
//  ErrorWithContext.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 17/04/16.
//  Copyright © 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public struct ErrorWithContext : Swift.Error {

    public let error  : NSError
    public let context: String

    public init(error: NSError, context: String) {

        self.error   = error
        self.context = context
    }
}
