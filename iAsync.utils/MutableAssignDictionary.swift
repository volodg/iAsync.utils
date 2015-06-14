//
//  MutableAssignDictionary.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 20.09.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public class MutableAssignDictionary<K: Hashable, V: AnyObject> : CustomStringConvertible {
    
    public init() {}
    
    private var mutDict: [K:JAutoRemoveFromDictAssignProxy<K, V>] = [:]
    
    private func removeAll(keepCapacity: Bool) {
        
        for (_, proxy) in mutDict {
            proxy.onRemoveFromMutableAssignDictionary(self)
        }
        
        mutDict.removeAll(keepCapacity: keepCapacity)
    }
    
    public var count: Int {
        return mutDict.count
    }
    
//    public func objectForKey(key: K) -> V? {
//    
//        return self[key]
//    }
//
//    public subscript(key: K) -> V? {
//        
//        get {
//            let proxy = mutDict[key]
//            return proxy?.target.takeUnretainedValue()
//        }
//        set (newValue) {
//            
//            var removed = false
//            
//            if self[key] != nil {
//                
//                removed = true
//                removeValueForKey(key)
//            }
//            
//            if let newValue = newValue {
//                
//                let proxy = JAutoRemoveFromDictAssignProxy<K, V>(target: newValue)
//                self.mutDict[key] = proxy
//                proxy.onAddToMutableAssignDictionary(self, key:key)
//            } else {
//
//                if !removed {
//                    removeValueForKey(key)
//                }
//            }
//        }
//    }
    
    public func map<R>(block: (K, V) -> R) -> [K:R] {
    
        return mutDict.map({ (key, proxy) -> R in
            
            return block(key, proxy.target.takeUnretainedValue())
        })
    }
    
    func removeValueForKey(key: K) {
        
        let proxy = mutDict[key]
        proxy?.onRemoveFromMutableAssignDictionary(self)
        mutDict.removeValueForKey(key)
    }
    
    public var dict: [K:V] {
        
        return mutDict.map { (key, proxy) -> V in
                
            return proxy.target.takeUnretainedValue()
        }
    }
    
    public var description: String {
        return dict.description
    }
    
    deinit {
        removeAll(false)
    }
}

private class JAutoRemoveFromDictAssignProxy<K: Hashable, V: AnyObject> : AssignObjectHolder<V> {
    
    weak var blockHolder: OnDeallocBlockOwner?
    
    init(target: V) {
        
        let ptr = Unmanaged<V>.passUnretained(target)
        super.init(targetPtr: ptr)
    }
    
    func onAddToMutableAssignDictionary(dict: MutableAssignDictionary<K, V>, key: K) {
        
        let unretainedDict = Unmanaged<MutableAssignDictionary<K, V>>.passUnretained(dict)
        
        let onDeallocBlock = {
            unretainedDict.takeUnretainedValue().removeValueForKey(key)
        }
        let blockHolder  = OnDeallocBlockOwner(block:onDeallocBlock)
        self.blockHolder = blockHolder
        (target.takeUnretainedValue() as! NSObject).addOnDeallocBlockHolder(blockHolder)
    }
    
    func onRemoveFromMutableAssignDictionary(dict: MutableAssignDictionary<K, V>) {
        
        if let blockHolder = self.blockHolder {
            blockHolder.block = nil
            self.blockHolder = nil
            (self.target.takeUnretainedValue() as! NSObject).removeOnDeallocBlockHolder(blockHolder)
        }
    }
}
