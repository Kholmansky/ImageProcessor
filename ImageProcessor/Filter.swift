//
//  Filter.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 01/07/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit

protocol Filter {

    func apply(for image: UIImage) -> UIImage?
}

enum TypeOfFilter: Filter {
    
    case rotate, mirror, invert
    
    func apply(for image: UIImage) -> UIImage? {
        
        switch self {
        case .invert:
            return InvertFilter().apply(for:image)
        case .rotate:
            return RotateFilter().apply(for:image)
        case .mirror:
            return MirrorFilter().apply(for:image)
        }
    }
}

class RotateFilter: Filter {
    
    func apply(for image: UIImage) -> UIImage? {
        
        let angle = CGFloat(Double.pi/2)
        let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let transform = CGAffineTransform(rotationAngle: angle)
        rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        guard let bitmap = UIGraphicsGetCurrentContext() else {
            return nil
        }
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: angle)
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(image.cgImage!, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width,height: image.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

class MirrorFilter: Filter {
    
    func apply(for image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContext(image.size)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: image.size.width, y: image.size.height)
        bitmap.scaleBy(x: -image.scale, y: -image.scale)
        bitmap.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

class InvertFilter: Filter {
    
    func apply(for image: UIImage) -> UIImage? {
        
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: "CIPhotoEffectMono" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let resultImage = UIImage(cgImage: filteredImageRef!)
        return resultImage
    }
}
