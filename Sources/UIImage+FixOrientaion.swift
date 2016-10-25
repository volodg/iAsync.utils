//
//  UIImage+FixOrientaion.swift
//  iAsync_utils
//
//  Created by Gorbenko Vladimir on 07.09.15.
//  Copyright © 2015 EmbeddedSources. All rights reserved.
//

import UIKit

extension UIImage {

    public func fixOrientation() -> UIImage? {

        // No-op if the orientation is already correct
        if imageOrientation == .up { return self }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break

        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat(M_PI_2))
            break
        case .up, .upMirrored:
            break
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break

        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .up, .down, .left, .right:
            break
        }

        guard let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace else { return nil }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx_ = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: cgImage.bitmapInfo.rawValue)

        guard let ctx = ctx_ else { return nil }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0,width: size.height, height: size.width))
            break

        case .up, .down, .upMirrored, .downMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0,y: 0, width: size.width, height: size.height))
            break
        }

        // And now we just create a new UIImage from the drawing context
        return ctx.makeImage().flatMap { UIImage(cgImage: $0) }
    }
}
