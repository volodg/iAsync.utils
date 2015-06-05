//
//  DictionaryHelperBlocks.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

//TODO make it template
public typealias DictMappingBlock = (key : AnyObject, object : AnyObject) -> AnyObject

//TODO make it template
public typealias DictOptionMappingBlock = (key : AnyObject, object : AnyObject) -> AnyObject?

//TODO make it template
public typealias DictMappingWithErrorBlock = (key : AnyObject, object : AnyObject, outError : NSErrorPointer) -> AnyObject?

//TODO make it template
public typealias DictPredicateBlock = (key : AnyObject, object : AnyObject) -> Bool
