//
//  AsyncResult.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 07.08.15.
//  Copyright (c) 2015 EmbeddedSources. All rights reserved.
//

import Foundation

/// An enum representing either a failure with an explanatory error, or a success with a result value.
public enum AsyncResult<T, Error: ErrorType>: CustomStringConvertible, CustomDebugStringConvertible {
    case Success(T)
    case Failure(Error)
    case Interrupted
    case Unsubscribed //TODO remove?

    // MARK: Constructors

    /// Constructs a success wrapping a `value`.
    public init(value: T) {
        self = .Success(value)
    }

    /// Constructs a failure wrapping an `error`.
    public init(error: Error) {
        self = .Failure(error)
    }

    /// Constructs a success wrapping a `value`.
    public static func success(value: T) -> AsyncResult {
        return AsyncResult(value: value)
    }

    /// Constructs a failure wrapping an `error`.
    public static func failure(error: Error) -> AsyncResult {
        return AsyncResult(error: error)
    }

    public func map<R>(@noescape transform: T -> R) -> AsyncResult<R, Error> {

        switch self {
        case .Success(let value):
            return AsyncResult<R, Error>.success(transform(value))
        case .Failure(let error):
            return .Failure(error)
        case .Interrupted:
            return .Interrupted
        case .Unsubscribed:
            return .Unsubscribed
        }
    }

    public func mapError<NewError: ErrorType>(@noescape transform: Error -> NewError) -> AsyncResult<T, NewError> {

        switch self {
        case .Success(let value):
            return .Success(value)
        case .Failure(let value):
            return AsyncResult<T, NewError>.failure(transform(value))
        case .Interrupted:
            return .Interrupted
        case .Unsubscribed:
            return .Unsubscribed
        }
    }

    public var interruptedOrUnsubscribed: Bool {
        switch self {
        case .Interrupted, .Unsubscribed:
            return true
        case .Success, .Failure:
            return false
        }
    }

    // MARK: Deconstruction

    /// Returns the value from `Success` Results, `nil` otherwise.
    public var value: T? {
        switch self {
        case .Success(let value):
            return value
        case .Failure, .Interrupted, .Unsubscribed:
            return nil
        }
    }

    /// Returns the error from `Failure` Results, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .Failure(let error):
            return error
        case .Success, .Interrupted, .Unsubscribed:
            return nil
        }
    }

    // MARK: Printable

    public var description: String {
        switch self {
        case .Success(let value):
            return ".Success(\(value))"
        case .Failure(let error):
            return ".Failure(\(error))"
        case .Interrupted:
            return ".Interrupted"
        case .Unsubscribed:
            return ".Unsubscribed"
        }
    }

    // MARK: DebugPrintable

    public var debugDescription: String {
        return description
    }
}
