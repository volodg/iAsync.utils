//
//  NSError+WriteErrorToNSLog.swift
//  iAsync_utils
//
//  Created by Vladimir Gorbenko on 06.06.14.
//  Copyright (c) 2014 EmbeddedSources. All rights reserved.
//

import Foundation

private struct ErrorWithAction {
    
    let error : NSError
    let action: SimpleBlock
}

private var nsLogErrorsQueue  : [ErrorWithAction] = []
private var jLoggerErrorsQueue: [ErrorWithAction] = []

private func delayedPerformAction(error: NSError, action: SimpleBlock, inout queue: [ErrorWithAction])
{
    if queue.firstMatch( { $0.error === error } ) != nil {
        return
    }
    
    queue.append(ErrorWithAction(error: error, action: action))
    
    if queue.count == 1 {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let tmpQueue = queue
            queue.removeAll(keepCapacity: true)
            for info in tmpQueue {
                info.action()
            }
        })
    }
}

public extension NSError {
    
    //TODO make it protected
    var errorLogDescription: String? {
        return "\(self.dynamicType) : \(localizedDescription), domain : \(domain) code : \(code.description)"
    }
    
    func writeErrorToNSLog() {
        
        let action = { () -> () in
            if let logStr = self.errorLogDescription {
                NSLog("only log - %@", logStr)
            }
        }
        
        delayedPerformAction(self, action: action, queue: &nsLogErrorsQueue)
    }
    
    func writeErrorWithJLogger() {
        
        let action = { () -> () in
            if let logStr = self.errorLogDescription {
                iAsync_utils_logger.logError(logStr)
            }
        }
        
        delayedPerformAction(self, action: action, queue: &jLoggerErrorsQueue)
    }
}
