//
//  SilentError.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 05.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public class SilentError : Error {

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(description: String) {
        super.init(description: description)
    }

    public override func writeErrorWithLogger() {
        writeErrorToNSLog()
    }
}
