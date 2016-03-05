//
//  UtilsBlockDefinitions.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

import ReactiveKit

public enum UtilsBlockDefinitions2<T1, T2, Error: ErrorType> {

    public typealias Analyzer = (object: T1) -> Result<T2, Error>
}
