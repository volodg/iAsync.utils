//
//  AsyncResult.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 07.08.15.
//  Copyright (c) 2015 EmbeddedSources. All rights reserved.
//

import Foundation

import Box

/// An enum representing either a failure with an explanatory error, or a success with a result value.
public enum AsyncResult<T, Error: ErrorType>: Printable, DebugPrintable {
    case Success(Box<T>)
    case Failure(Box<Error>)
    case Interrupted
    case Unsubscribed //TODO remove?
    
    // MARK: Constructors
    
    /// Constructs a success wrapping a `value`.
    public init(value: T) {
        self = .Success(Box(value))
    }
    
    /// Constructs a failure wrapping an `error`.
    public init(error: Error) {
        self = .Failure(Box(error))
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
        case .Success(let v):
            return AsyncResult<R, Error>.success(transform(v.value))
        case .Failure(let v):
            return .Failure(v)
        case .Interrupted:
            return .Interrupted
        case .Unsubscribed:
            return .Unsubscribed
        }
    }
    
    public func mapError<NewError: ErrorType>(@noescape transform: Error -> NewError) -> AsyncResult<T, NewError> {
        
        switch self {
        case .Success(let v):
            return .Success(v)
        case .Failure(let v):
            return AsyncResult<T, NewError>.failure(transform(v.value))
        case .Interrupted:
            return .Interrupted
        case .Unsubscribed:
            return .Unsubscribed
        }
    }
    
    public var interruptedOrUnsubscribed: Bool {
        switch self {
        case .Interrupted:
            return true
        case .Unsubscribed:
            return true
        default:
            return false
        }
    }
    
    // MARK: Deconstruction
    
    /// Returns the value from `Success` Results, `nil` otherwise.
    public var value: T? {
        switch self {
        case .Success(let value):
            return value.value
        default:
            return nil
        }
    }
    
    /// Returns the error from `Failure` Results, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .Failure(let error):
            return error.value
        default:
            return nil
        }
    }
    
    // MARK: Printable
    
    public var description: String {
        switch self {
        case .Success(let value):
            return ".Success(\(value.value))"
        case .Failure(let error):
            return ".Failure(\(error.value))"
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
