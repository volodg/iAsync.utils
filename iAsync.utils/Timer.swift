//
//  Timer.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 26.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public typealias JCancelScheduledBlock = () -> Void
public typealias JScheduledBlock = (cancel: JCancelScheduledBlock) -> Void

private let emptyTimerBlock: () -> Void = {}

final public class Timer {
    
    private var cancelBlocks = [SimpleBlockHolder]()
    
    public init() {}
    
    deinit {
        cancelAllScheduledOperations()
    }
    
    public func cancelAllScheduledOperations()
    {
        let cancelBlocks = self.cancelBlocks
        self.cancelBlocks.removeAll(keepCapacity: true)
        for cancelHolder in cancelBlocks {
            cancelHolder.onceSimpleBlock()()
        }
    }
    
    public static func sharedByThreadTimer() -> Timer {
        
        let thread = NSThread.currentThread()
        
        let key = "iAsync.utils.Timer.threadLocalTimer"
        
        if let result = thread.threadDictionary[key] as? Timer {
            
            return result
        }
        
        let result = Timer()
        thread.threadDictionary[key] = result
        
        return result
    }
    
    func addBlock(actionBlock: JScheduledBlock,
        duration     : NSTimeInterval,
        dispatchQueue: dispatch_queue_t) -> JCancelScheduledBlock
    {
        return self.addBlock(actionBlock,
            duration     : duration,
            leeway       : duration/10.0,
            dispatchQueue: dispatchQueue)
    }
    
    public func addBlock(
        actionBlock  : JScheduledBlock,
        duration     : NSTimeInterval,
        leeway       : NSTimeInterval,
        dispatchQueue: dispatch_queue_t) -> JCancelScheduledBlock
    {
        var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue)
        
        let delta = Int64(duration * Double(NSEC_PER_SEC))
        dispatch_source_set_timer(timer,
            dispatch_time(DISPATCH_TIME_NOW, delta),
            UInt64(delta),
            UInt64(leeway * Double(NSEC_PER_SEC)))
        
        let cancelTimerBlockHolder = SimpleBlockHolder()
        weak var weakCancelTimerBlockHolder = cancelTimerBlockHolder
        
        cancelTimerBlockHolder.simpleBlock = { [weak self] () -> () in
            
            if timer == nil {
                return
            }
            
            dispatch_source_set_event_handler(timer, emptyTimerBlock)
            dispatch_source_cancel(timer)
            timer = nil
            
            if let self_ = self {
                for (index, cancelHolder) in self_.cancelBlocks.enumerate() {
                    
                    if cancelHolder === weakCancelTimerBlockHolder! {
                        self_.cancelBlocks.removeAtIndex(index)
                        weakCancelTimerBlockHolder = nil
                        break
                    }
                }
            }
        }
        
        cancelBlocks.append(cancelTimerBlockHolder)
        
        let eventHandlerBlock = { () -> () in
            actionBlock(cancel: cancelTimerBlockHolder.onceSimpleBlock())
        }
        
        dispatch_source_set_event_handler(timer, eventHandlerBlock)
        
        dispatch_resume(timer)
        
        return cancelTimerBlockHolder.onceSimpleBlock()
    }
    
    public func addBlock(actionBlock: JScheduledBlock,
        duration: NSTimeInterval) -> JCancelScheduledBlock
    {
        return addBlock(actionBlock,
            duration: duration,
            leeway  : duration/10.0)
    }
    
    public func addBlock(actionBlock: JScheduledBlock,
        duration: NSTimeInterval,
        leeway  : NSTimeInterval) -> JCancelScheduledBlock
    {
        return addBlock(actionBlock,
            duration     : duration,
            leeway       : leeway,
            dispatchQueue: dispatch_get_main_queue())
    }
}
