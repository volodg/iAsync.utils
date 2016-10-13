//
//  UtilsError.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 05.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public protocol CanRepeatError {

    var canRepeatError: Bool { get }
}

//TODO should be protocol?
open class UtilsError : Error, LoggedObject, CanRepeatError {

    public let _description: String

    public init(description: String) {

        self._description = description//todo localize str here
    }

    open var localizedDescription: String {
        return "\(type(of: self)) with description: \(_description)"
    }

    open var logTarget: LogTarget {
        return LogTarget.logger
    }

    open var errorLogText: String {

        let result = "\(type(of: self)) : \(localizedDescription)"
        return result
    }

    open var errorLog: [String:String] {
        let log = errorLogText
        let result = [
            "Text" : log,
            "Type" : "\(type(of: self))"
        ]
        return result
    }

    open var canRepeatError: Bool {

        return false
    }
}

public final class WrapperOfNSError : UtilsError {

    public let error: NSError

    public init(forError error: NSError) {

        self.error = error
        super.init(description: error.localizedDescription)
    }

    public convenience init(forError error: Error) {

        self.init(forError: error as NSError)
    }
}
