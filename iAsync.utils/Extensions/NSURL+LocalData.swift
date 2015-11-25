//
//  NSURL+LocalData.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 25.11.15.
//  Copyright (c) 2015 EmbeddedSources. All rights reserved.
//

import Foundation

import AssetsLibrary

extension NSURL {

    public func isAssetURL() -> Bool {

        return self.scheme == "assets-library"
    }

    public func localDataWithCallbacks(onData: (NSData) -> Void, onError: (NSError) -> Void) {

        if isAssetURL() {

            let assetLibrary = ALAssetsLibrary()

            assetLibrary.assetForURL(self, resultBlock: { (asset) -> Void in

                let rep      = asset.defaultRepresentation()
                let buffer   = UnsafeMutablePointer<UInt8>.alloc(Int(rep.size()))
                let buffered = rep.getBytes(buffer, fromOffset: 0, length: Int(rep.size()), error: nil)
                let data     = NSData(bytesNoCopy: buffer, length: buffered, freeWhenDone: true)

                onData(data)
            }, failureBlock: { (error) -> Void in

                onError(error)
            })

            return
        }

        if let result = NSData(contentsOfURL: self) {
            onData(result)
        } else {
            onError(Error(description: "no data for local url: \(self)"))
        }
    }
}
