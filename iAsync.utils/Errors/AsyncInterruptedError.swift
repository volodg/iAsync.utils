//
//  AsyncInterruptedError.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 08/02/16.
//  Copyright (c) 2016 EmbeddedSources. All rights reserved.
//

import Foundation

public class AsyncInterruptedError : SilentError {

    public init() {
        super.init(description: "AsyncInterruptedError")
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
