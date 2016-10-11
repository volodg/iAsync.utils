//
//  NSError+WriteErrorToNSLog.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

private struct ErrorWithAction {

    let error : ErrorWithContext
    let action: (() -> ())
}

final private class ActionsHolder {

    var queue = [ErrorWithAction]()
}

private var nsLogErrorsQueue   = ActionsHolder()
private var jLoggerErrorsQueue = ActionsHolder()

//todo rename?
private func delayedPerformAction(_ error: ErrorWithContext, action: @escaping (() -> ()), queue: ActionsHolder) {

    if queue.queue.index(where: { $0.error.error === error.error && $0.error.context == error.context }) != nil {
        return
    }

    queue.queue.append(ErrorWithAction(error: error, action: action))

    if queue.queue.count == 1 {

        DispatchQueue.main.async(execute: {

            let tmpQueue = queue.queue
            queue.queue.removeAll(keepingCapacity: true)
            for info in tmpQueue {
                info.action()
            }
        })
    }
}

public extension LoggedObject where Self : NSError {

    var logTarget: LogTarget {
        return LogTarget.logger
    }

    var errorLogText: String {

        let result = "\(type(of: self)) : \(localizedDescription), domain : \(domain) code : \(code.description)"
        return result
    }

    var errorLog: [String:String] {
        let log = errorLogText
        let result = [
            "Text" : log,
            "Type" : type(of: self).description()
        ]
        return result
    }
}

//todo rename?
public func debugOnlyPrint(_ str: String) {

    if _isDebugAssertConfiguration() {
        print(str)
    }
}

public extension ErrorWithContext {

    func postToLog() {

        if let object = self.error as? LoggedObject {
            switch object.logTarget {
            case .logger:
                let action = { () in
                    var log = object.errorLog
                    log["Context"] = self.context
                    iAsync_utils_logger.logWith(level: .logError, log: log)
                }

                delayedPerformAction(self, action: action, queue: jLoggerErrorsQueue)
            case .console:
                let action = { () in
                    let log = object.errorLog
                    debugOnlyPrint("only log - \(log) context - \(self.context)")
                }

                delayedPerformAction(self, action: action, queue: nsLogErrorsQueue)
            case .nothing:
                break
            }
        } else {
            //swift3 assert(false)
        }
    }
}
