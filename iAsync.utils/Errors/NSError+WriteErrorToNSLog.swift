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

public enum LogTarget: Int {

    case logger
    case console
    case nothing
}

public extension NSError {

    public var errorLogText: String {

        let result = "\(type(of: self)) : \(localizedDescription), domain : \(domain) code : \(code.description)"
        return result
    }

    //return type NSDictionary is workaround, should be a [String:String]
    public var errorLog: [String:String] {
        let log = errorLogText
        let result = [
            "Text" : log,
            "Type" : type(of: self).description()
        ]
        return result
    }

    //return type Int is workaround, should be a LogTarget
    public var logTarget: Int {
        return LogTarget.logger.rawValue
    }
}

public func debugOnlyPrint(_ str: String) {

    if _isDebugAssertConfiguration() {
        print(str)
    }
}

public extension ErrorWithContext {

    func postToLog() {

        if let target = LogTarget(rawValue: error.logTarget) {
            switch target {
            case .logger:
                let action = { () in
                    var log = self.error.errorLog
                    log["Context"] = self.context
                    iAsync_utils_logger.logWith(level: .LogError, log: log)
                }

                delayedPerformAction(self, action: action, queue: jLoggerErrorsQueue)
            case .console:
                let action = { () in
                    let log = self.error.errorLog
                    debugOnlyPrint("only log - \(log) context - \(self.context)")
                }

                delayedPerformAction(self, action: action, queue: nsLogErrorsQueue)
            case .nothing:
                break
            }
        } else {
            assert(false)
        }
    }
}
