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

    func addBlock(
        _ actionBlock  : @escaping JScheduledBlock,
        duration     : TimeInterval,
        dispatchQueue: DispatchQueue) -> JCancelScheduledBlock {

        return self.addBlock(actionBlock,
                             duration     : duration,
                             leeway       : duration/10.0,
                             dispatchQueue: dispatchQueue)
    }

    var timer :DispatchSourceTimer?

    public func addBlock(
        _ actionBlock  : @escaping JScheduledBlock,
        duration     : TimeInterval,
        leeway       : TimeInterval,
        dispatchQueue: DispatchQueue) -> JCancelScheduledBlock {

        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: dispatchQueue)
        self.timer = timer

        var actionBlockHolder: JScheduledBlock? = actionBlock

        timer.scheduleRepeating(
            deadline: DispatchTime.now() + duration,
            interval: DispatchTimeInterval.milliseconds(Int(duration)),
            leeway  : DispatchTimeInterval.milliseconds(Int(leeway))
        )

        let cancelTimerBlockHolder = SimpleBlockHolder()
        weak var weakCancelTimerBlockHolder = cancelTimerBlockHolder

        cancelTimerBlockHolder.simpleBlock = { [weak self, weak timer] () -> () in

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

        timer.setEventHandler(handler: eventHandlerBlock)

        timer.resume()

        return cancelTimerBlockHolder.onceSimpleBlock()
    }

    public func addBlock(
        _ actionBlock: @escaping JScheduledBlock,
        duration   : TimeInterval) -> JCancelScheduledBlock {

        return addBlock(actionBlock,
                        duration: duration,
                        leeway  : duration/10.0)
    }

    public func addBlock(_ actionBlock: @escaping JScheduledBlock,
                         duration: TimeInterval,
                         leeway  : TimeInterval) -> JCancelScheduledBlock {

        return addBlock(actionBlock,
                        duration     : duration,
                        leeway       : leeway,
                        dispatchQueue: DispatchQueue.main)
    }
}
