//
//  Logger.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 05.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public typealias LogHandler = (level: LogLevel, log: [String:String]) -> Void

private var staticLogHandler: LogHandler? = nil

public let iAsync_utils_logger = Logger()

public enum LogLevel: String {

    case LogError = "error"
    case LogInfo  = "info"
}

final public class Logger {

    private init() {}

    public var logHandler: LogHandler {
        get {
            if let result = staticLogHandler {
                return result
            }
            let result = { (level: LogLevel, log: [String:String]) in
                print("\(level): \(log)")
            }
            staticLogHandler = result
            return result
        }
        set(newLogHandler) {
            staticLogHandler = newLogHandler
        }
    }

    public func logError(log: String, context: String? = nil) {
        logWith(level: .LogError, log: log, context: context)
    }

    public func logInfo(log: String, context: String? = nil) {
        logWith(level: .LogInfo, log: log, context: context)
    }

    public func logWith(level level: LogLevel, log: String, context: String?) {
        var log = [ "Text" : log ]
        if let context = context {
            log["Context"] = context
        }
        logHandler(level: level, log: log)
    }

    public func logWith(level level: LogLevel, log: [String:String]) {
        logHandler(level: level, log: log)
    }
}
