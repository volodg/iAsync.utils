//
//  AsyncInterruptedError.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 08/02/16.
//  Copyright © 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public final class AsyncInterruptedError : SilentError {

    public init() {
        super.init(description: "AsyncInterruptedError")
    }
}
