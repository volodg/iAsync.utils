//
//  SimpleBlockHolder.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 11.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

final public class SimpleBlockHolder : NSObject {

    public var simpleBlock: (() -> ())?

    public func onceSimpleBlock() -> (() -> ()) {

        return {

            if let block = self.simpleBlock {
                self.simpleBlock = nil
                block()
            }
        }
    }
}
