//
//  NSURL+LocalData.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 25.11.15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import Foundation

import AssetsLibrary

public final class CanNotSelectPhotoError : UtilsError {

    let url: NSURL
    init(url: NSURL) {
        self.url = url
        super.init(description: "")
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var errorLogText: String {
        let result = "<CanNotSelectPhotoError url: \(url)>"
        return result
    }
}

extension NSURL {

    public func isAssetURL() -> Bool {

        return scheme == "assets-library"
    }

    public func localDataWithCallbacks(onData: NSData -> Void, onError: ErrorWithContext -> Void) {

        if isAssetURL() {

            let assetLibrary = ALAssetsLibrary()

            assetLibrary.assetForURL(self, resultBlock: { asset in

                if let asset = asset {
                    let rep      = asset.defaultRepresentation()
                    let buffer   = UnsafeMutablePointer<UInt8>.alloc(Int(rep.size()))
                    let buffered = rep.getBytes(buffer, fromOffset: 0, length: Int(rep.size()), error: nil)
                    let data     = NSData(bytesNoCopy: buffer, length: buffered, freeWhenDone: true)

                    onData(data)
                } else {

                    let error = ErrorWithContext(error: CanNotSelectPhotoError(url: self), context: #function + ":1")
                    onError(error)
                }
            }, failureBlock: { error in

                if let error = error {

                    let contextError = ErrorWithContext(error: error, context: #function)
                    onError(contextError)
                } else {

                    let contextError = ErrorWithContext(error: CanNotSelectPhotoError(url: self), context: #function + ":2")
                    onError(contextError)
                }
            })

            return
        }

        if let result = NSData(contentsOfURL: self) {
            onData(result)
        } else {
            let contextError = ErrorWithContext(error: CanNotSelectPhotoError(url: self), context: #function + ":3")
            onError(contextError)
        }
    }
}
