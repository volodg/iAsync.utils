//
//  Timer.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 26.06.14.
//  Copyright © 2014 EmbeddedSources. All rights reserved.
//

import Foundation

public typealias JCancelScheduledBlock = () -> Void
public typealias JScheduledBlock = (_ cancel: JCancelScheduledBlock) -> Void

private let emptyTimerBlock: () -> Void = {}

final public class Timer {

    fileprivate var cancelBlocks = [SimpleBlockHolder]()

    public init() {}

    deinit {
        cancelAllScheduledOperations()
    }

    public func cancelAllScheduledOperations() {

        let cancelBlocks = self.cancelBlocks
        self.cancelBlocks.removeAll(keepingCapacity: true)
        for cancelHolder in cancelBlocks {
            cancelHolder.onceSimpleBlock()()
        }
    }

    public static func sharedByThreadTimer() -> Timer {

        let thread = Thread.current

        let key = "iAsync.utils.Timer.threadLocalTimer"

        if let result = thread.threadDictionary[key] as? Timer {

            return result
        }

        let result = Timer()
        thread.threadDictionary[key] = result

        return result
    }

    public func addBlock(
        _ actionBlock: @escaping JScheduledBlock,
        delay        : DispatchTimeInterval,
        interval     : DispatchTimeInterval,
        dispatchQueue: DispatchQueue = DispatchQueue.main) -> JCancelScheduledBlock {

        var initialTimer = DispatchSource.makeTimerSource(queue: dispatchQueue)
        var timer: DispatchSourceTimer? = initialTimer

        var actionBlockHolder: JScheduledBlock? = actionBlock

        initialTimer.scheduleRepeating(
            deadline: DispatchTime.now() + delay,
            interval: interval)

        let cancelTimerBlockHolder = SimpleBlockHolder()
        weak var weakCancelTimerBlockHolder = cancelTimerBlockHolder

        cancelTimerBlockHolder.simpleBlock = { [weak self] () -> () in

            guard let timer_ = timer else { return }

            actionBlockHolder = nil
            timer_.setEventHandler(handler: emptyTimerBlock)
            timer_.cancel()
            timer = nil

            guard let self_ = self else { return }

            for (index, cancelHolder) in self_.cancelBlocks.enumerated() {

                if cancelHolder === weakCancelTimerBlockHolder {
                    self_.cancelBlocks.remove(at: index)
                    weakCancelTimerBlockHolder = nil
                    break
                }
            }
        }

        cancelBlocks.append(cancelTimerBlockHolder)

        let eventHandlerBlock = { () -> () in
            actionBlockHolder?(cancelTimerBlockHolder.onceSimpleBlock())
        }

        initialTimer.setEventHandler(handler: eventHandlerBlock)

        initialTimer.resume()

        return cancelTimerBlockHolder.onceSimpleBlock()
    }

    public func addBlock(_ actionBlock: @escaping JScheduledBlock,
                         delay : DispatchTimeInterval,
                         dispatchQueue: DispatchQueue = DispatchQueue.main) -> JCancelScheduledBlock {

        return addBlock(actionBlock,
                        delay   : delay,
                        interval: delay,
                        dispatchQueue: dispatchQueue)
    }
}
