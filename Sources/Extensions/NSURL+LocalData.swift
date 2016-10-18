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

    let url: URL
    init(url: URL) {
        self.url = url
        super.init(description: "")
    }

    override open var errorLogText: String {

        let result = "<CanNotSelectPhotoError url: \(url)>"
        return result
    }
}

extension URL {

    public func isAssetURL() -> Bool {

        return scheme == "assets-library"
    }

    public func getLocalData(onData: @escaping (Data) -> Void, onError: @escaping (ErrorWithContext) -> Void) {

        if isAssetURL() {

            let assetLibrary = ALAssetsLibrary()

            assetLibrary.asset(for: self, resultBlock: { asset in

                if let asset = asset {
                    let rep      = asset.defaultRepresentation()
                    let buffer   = UnsafeMutablePointer<UInt8>.allocate(capacity: Int((rep?.size())!))
                    let buffered = rep?.getBytes(buffer, fromOffset: 0, length: Int((rep?.size())!), error: nil)
                    let data     = Data(bytesNoCopy: UnsafeMutablePointer<UInt8>(buffer), count: buffered!, deallocator: .free)

                    onData(data)
                } else {

                    let error = ErrorWithContext(utilsError: CanNotSelectPhotoError(url: self), context: #function + ":1")
                    onError(error)
                }
            }, failureBlock: { error in

                if let error = error {

                    let contextError = ErrorWithContext(genericError: error, context: #function)
                    onError(contextError)
                } else {

                    let contextError = ErrorWithContext(utilsError: CanNotSelectPhotoError(url: self), context: #function + ":2")
                    onError(contextError)
                }
            })

            return
        }

        if let result = try? Data(contentsOf: self) {
            onData(result)
        } else {
            let contextError = ErrorWithContext(utilsError: CanNotSelectPhotoError(url: self), context: #function + ":3")
            onError(contextError)
        }
    }
}
