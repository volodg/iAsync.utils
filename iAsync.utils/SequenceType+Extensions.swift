//
//  SequenceType+Extensions.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 01.10.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension SequenceType {
    
    public func firstMatch(
        @noescape predicate: (value: Generator.Element) -> Bool) -> Generator.Element?
    {
        for object in self {
            if predicate(value: object) {
                return object
            }
        }
        return nil
    }
    
    public func indexOf(
        @noescape predicate: (value: Generator.Element) -> Bool) -> Int
    {
        for (index, element) in enumerate() {
            if predicate(value: element) {
                return index
            }
        }
        return Int.max
    }
    
    public func optionIndexOf(
        @noescape predicate: (value: Generator.Element) -> Bool) -> Int?
    {
        for (index, element) in enumerate() {
            if predicate(value: element) {
                return index
            }
        }
        return nil
    }
    
    public func any(@noescape predicate : (Generator.Element) -> Bool) -> Bool {
        let object = firstMatch(predicate)
        return object != nil
    }
    
    public func all(@noescape predicate : (Generator.Element) -> Bool) -> Bool {
        return !any { (object: Generator.Element) -> Bool in
            return !predicate(object)
        }
    }
}

//TODO refactor
public func >>=<Sequence: SequenceType, R>(obj: Sequence, f: Sequence.Generator.Element -> Result<R>) -> Result<[R]> {
    
    var result = [R]()
    
    for object in obj {
        
        let newObject = f(object)
        
        switch newObject {
        case let .Error(e):
            return Result.error(e)
        case let .Value(value):
            result.append(value)
        }
    }
    
    return Result.value(result)
}
