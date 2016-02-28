//
//  NSError+WriteErrorToNSLog.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

private struct ErrorWithAction {

    let error : NSError
    let action: SimpleBlock
}

final private class ActionsHolder {

    var queue = [ErrorWithAction]()
}

private var nsLogErrorsQueue   = ActionsHolder()
private var jLoggerErrorsQueue = ActionsHolder()

private func delayedPerformAction(error: NSError, action: SimpleBlock, queue: ActionsHolder) {

    if queue.queue.indexOf({ $0.error === error }) != nil {
        return
    }

    queue.queue.append(ErrorWithAction(error: error, action: action))

    if queue.queue.count == 1 {

        dispatch_async(dispatch_get_main_queue(), {

            let tmpQueue = queue.queue
            queue.queue.removeAll(keepCapacity: true)
            for info in tmpQueue {
                info.action()
            }
        })
    }
}

public extension NSError {

    var errorLogDescription: String? {
        return "\(self.dynamicType) : \(localizedDescription), domain : \(domain) code : \(code.description)"
    }

    func writeErrorToNSLog() {

        let action = { () in
            if let logStr = self.errorLogDescription {
                print("only log - \(logStr)")
            }
        }

        delayedPerformAction(self, action: action, queue: nsLogErrorsQueue)
    }

    func writeErrorWithLogger() {

        let action = { () in
            if let logStr = self.errorLogDescription {
                iAsync_utils_logger.logError(logStr)
            }
        }

        delayedPerformAction(self, action: action, queue: jLoggerErrorsQueue)
    }
}
