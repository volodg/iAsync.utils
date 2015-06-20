//
//  UtilsBlockDefinitions.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

import Result

public typealias SimpleBlock = () -> ()

public enum UtilsBlockDefinitions<T> {
    
    public typealias PredicateBlock = (object: T) -> Bool
}

public enum UtilsBlockDefinitions2<T1, T2> {
    
    public typealias JMappingBlock = (object: T1) -> T2
    
    public typealias JAnalyzer = (object: T1) -> Result<T2, NSError>
}
