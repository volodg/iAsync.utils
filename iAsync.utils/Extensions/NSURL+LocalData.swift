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

        return scheme == "assets-library"
    }

    public func localDataWithCallbacks(onData: (NSData) -> Void, onError: (NSError) -> Void) {

        if isAssetURL() {

            let assetLibrary = ALAssetsLibrary()

            assetLibrary.assetForURL(self, resultBlock: { (asset) -> Void in

                if let asset = asset {
                    let rep      = asset.defaultRepresentation()
                    let buffer   = UnsafeMutablePointer<UInt8>.alloc(Int(rep.size()))
                    let buffered = rep.getBytes(buffer, fromOffset: 0, length: Int(rep.size()), error: nil)
                    let data     = NSData(bytesNoCopy: buffer, length: buffered, freeWhenDone: true)

                    onData(data)
                } else {

                    onError(SilentError(description: "no data for local url: \(self)"))
                }
            }, failureBlock: { (error) -> Void in

                if let error = error {

                    onError(error)
                } else {

                    onError(SilentError(description: "no data for local url: \(self)"))
                }
            })

            return
        }

        if let result = NSData(contentsOfURL: self) {
            onData(result)
        } else {
            onError(SilentError(description: "no data for local url: \(self)"))
        }
    }
}