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

    var notify: ((_ watcher: DeallocWatcher<Key>, _ keys: Set<Key>)->Void)?
    let owner: UnsafeRawPointer
    fileprivate var keys = Set<Key>()

    func insertKey(_ key: Key) {
        keys.insert(key)
    }

    init(_ notify:@escaping (_ watcher: DeallocWatcher<Key>, _ keys: Set<Key>)->Void, owner: UnsafeRawPointer) {
        self.notify = notify
        self.owner  = owner
    }

    deinit { notify?(self, keys) }
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

                let owner = Unmanaged.passUnretained(o).toOpaque()

                if let watcher = objc_getAssociatedObject(o, Unmanaged.passUnretained(self).toOpaque()) as? DeallocWatcher<Key> {

                    watcher.insertKey(key)
                } else {
                    let watcher = DeallocWatcher({ [unowned self] (watcher: DeallocWatcher<Key>, keys: Set<Key>) in

                        for key in keys {

                            if watcher.owner == self.mapping[key]?.rawPtr {

                                self.mapping[key] = nil
                            }
                        }
                    }, owner: owner)

                    watcher.insertKey(key)

                    objc_setAssociatedObject(o, Unmanaged.passUnretained(self).toOpaque(), watcher, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }

                mapping[key] = WeakBox(o)
            } else {
                guard let index = mapping.index(forKey: key) else { return }

                let (_, value) = mapping[index]
                objc_setAssociatedObject(value.raw, Unmanaged.passUnretained(self).toOpaque(), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                mapping.remove(at: index)
            }
        }
    }

    public var count: Int { return mapping.count }

    deinit {
        // cleanup
        for e in self.mapping.values {

            if let val = e.raw, let watcher = objc_getAssociatedObject(val, Unmanaged.passUnretained(self).toOpaque()) as? DeallocWatcher<Key> {

                watcher.notify = nil

                objc_setAssociatedObject(e.raw, Unmanaged.passUnretained(self).toOpaque(), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
