//
//  UIImage+FixOrientaion.swift
//  Pods
//
//  Created by Gorbenko Vladimir on 07.09.15.
//
//

import Foundation

extension UIImage {
    
    public func fixOrientation() -> UIImage? {
        
        // No-op if the orientation is already correct
        if imageOrientation == .Up { return self }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransformIdentity
        
        switch imageOrientation {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
            
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
            
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2))
            break
        case .Up, .UpMirrored:
            break
        }
        
        switch imageOrientation {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
            
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        case .Up, .Down, .Left, .Right:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGBitmapContextCreate(
            nil,
            Int(size.width),
            Int(size.height),
            CGImageGetBitsPerComponent(CGImage),
            0,
            CGImageGetColorSpace(CGImage),
            CGImageGetBitmapInfo(CGImage))
        
        CGContextConcatCTM(ctx, transform)
        
        switch imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,size.height,size.width), CGImage)
            break
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0, size.width, size.height), CGImage)
            break
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx)
        let img = UIImage(CGImage:cgimg)
        return img
    }
}
