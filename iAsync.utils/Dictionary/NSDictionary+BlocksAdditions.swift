//
//  NSDictionary+BlocksAdditions.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 07.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public extension NSDictionary {
    
    func map(block: DictMappingBlock) -> NSDictionary {
        
        let result = NSMutableDictionary(capacity : count)
        
        enumerateKeysAndObjectsUsingBlock({(key : AnyObject!, object : AnyObject!, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            
            let newObject : AnyObject = block(key: key, object: object)
            result[key as! NSCopying] = newObject
        })
        
        return result.copy() as! NSDictionary
    }
    
    func forceMap(block: DictOptionMappingBlock) -> NSDictionary {
        
        let result = NSMutableDictionary(capacity : count)
        
        enumerateKeysAndObjectsUsingBlock({(key : AnyObject!, object : AnyObject!, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            
            let newObject : AnyObject? = block(key : key, object : object)
            if let value : AnyObject = newObject {
                result[key as! NSCopying] = value
            }
        })
        
        return result.copy() as! NSDictionary
    }
    
    func map(block: DictMappingWithErrorBlock, outError: NSErrorPointer) -> NSDictionary? {
        
        var result: NSMutableDictionary? = NSMutableDictionary(capacity: count)
        
        enumerateKeysAndObjectsUsingBlock({(key: AnyObject!, object: AnyObject!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            let newObject : AnyObject? = block(key: key, object: object, outError: outError)
            
            if let value : AnyObject = newObject {
                
                result![key as! NSCopying] = value
            } else {
                
                if stop != nil {
                    stop.memory = true
                }
                result = nil
            }
        })
        
        return result?.copy() as? NSDictionary
    }
    
    func mapKey(block: DictMappingBlock) -> NSDictionary {
        
        let result = NSMutableDictionary(capacity : count)
        
        enumerateKeysAndObjectsUsingBlock({(key : AnyObject!, object : AnyObject!, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            
            let newKey : AnyObject = block(key: key, object: object)
            //NSParameterAssert(newKey)
            result[newKey as! NSCopying] = object
        })
        
        return result.copy() as! NSDictionary
    }
    
    func count(predicate: DictPredicateBlock) -> Int {
        
        var count = 0
        
        enumerateKeysAndObjectsUsingBlock({(key : AnyObject!, object : AnyObject!, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            if predicate(key: key, object: object) {
                ++count
            }
        })
        return count
    }
    
    func filter(predicate: DictPredicateBlock) -> NSDictionary {
        
        let result = NSMutableDictionary(capacity: count)
        
        enumerateKeysAndObjectsUsingBlock({(key : AnyObject!, object : AnyObject!, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            
            if predicate(key: key, object: object) {
                result[key as! NSCopying] = object
            }
        })
        
        return result.copy() as! NSDictionary
    }
}
