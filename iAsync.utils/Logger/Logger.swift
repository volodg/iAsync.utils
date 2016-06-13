//
//  Logger.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 05.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public typealias LogHandler = (level: String, log: String, context: AnyObject?) -> Void

private var staticLogHandler: LogHandler? = nil

public let iAsync_utils_logger = Logger()

final public class Logger {

    private init() {}

    public var logHandler: LogHandler {
        get {
            if let result = staticLogHandler {
                return result
            }
            let result = { (level: String, log: String, context: AnyObject?) in
                print("\(log): \(level)")
            }
            staticLogHandler = result
            return result
        }
        set(newLogHandler) {
            staticLogHandler = newLogHandler
        }
    }

    public func logError(log: String) {
        logHandler(level: "error", log: log, context: nil)
    }

    public func logError(log: String, context: AnyObject) {
        logHandler(level: "error", log: log, context: context)
    }

    func logInfo(log: String) {
        logHandler(level: "info", log: log, context: nil)
    }

    func log(level: String, context: AnyObject, log: String) {
        logHandler(level: level, log: log, context: context)
    }
}
