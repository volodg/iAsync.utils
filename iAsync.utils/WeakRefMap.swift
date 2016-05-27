//
//  WeakRefMap.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 16.09.15.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

//source - http://stackoverflow.com/questions/28670796/can-i-hook-when-a-weakly-referenced-object-of-arbitrary-type-is-freed

private final class DeallocWatcher<Key: Hashable> {

    let notify:(keys: Set<Key>)->Void

    private var keys = Set<Key>()

    func insertKey(key: Key) {
        keys.insert(key)
    }

    init(_ notify:(keys: Set<Key>)->Void) { self.notify = notify }
    deinit { notify(keys: keys) }
}

//TODO : SequenceType
public final class WeakRefMap<Key: Hashable, Value: AnyObject> {

    public var mapping = [Key: WeakBox<Value>]()

    public func removeAll() {

        mapping.removeAll()
    }

    public init() {}

    public subscript(key: Key) -> Value? {
        get { return mapping[key]?.raw }
        set {
            if let o = newValue {
                // Add helper to associated objects.
                // When `o` is deallocated, `watcher` is also deallocated.
                // So, `watcher.deinit()` will get called.

                if let watcher = objc_getAssociatedObject(o, unsafeAddressOf(self)) as? DeallocWatcher<Key> {

                    watcher.insertKey(key)
                } else {

                    let watcher = DeallocWatcher { [unowned self] (keys: Set<Key>) in
                        for key in keys {
                            self.mapping[key] = nil
                        }
                    }

                    watcher.insertKey(key)

                    objc_setAssociatedObject(o, unsafeAddressOf(self), watcher, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }

                mapping[key] = WeakBox(o)
            } else {
                guard let index = mapping.indexForKey(key) else { return }

                let (_, value) = mapping[index]
                objc_setAssociatedObject(value.raw, unsafeAddressOf(self), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                mapping.removeAtIndex(index)
            }
        }
    }

    public var count: Int { return mapping.count }

    deinit {
        // cleanup
        for e in self.mapping.values {
            objc_setAssociatedObject(e.raw, unsafeAddressOf(self), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
