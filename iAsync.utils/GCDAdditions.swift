//
//  JGCDAdditions.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 21.09.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

private let lockObject = NSObject()
private var onceToken : Int = 0

private var dispatchByLabel = [String:DispatchQueue]()

public func dispatch_queue_get_or_create(label: String, attr: DispatchQueue.Attributes) -> DispatchQueue {

    return synced(lockObject) { () -> DispatchQueue in

        if let result = dispatchByLabel[label] {
            return result
        }

        let result = DispatchQueue(label: label, attributes: attr)
        dispatchByLabel[label] = result

        return result
    }
}
