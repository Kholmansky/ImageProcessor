//
//  ImageProcessor.swift
//  ImageProcessor
//
//  Created by IOS developer on 19/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit

final class ImageProcessor {
	
	static let shared = ImageProcessor()
	
	private init() {
	
    }
	
	var history = [Image]()
	
	func applyFilter(image: UIImage, filter: Int) -> UIImage? {
		switch filter {
		case 0:
			return rotateFilter(image: image)
		case 1:
			return invertFilter(image: image)
		case 2:
			return mirrorFilter(image: image)
		default:
			return nil
		}
	}
	
	func rotateFilter(image: UIImage) -> UIImage? {
        
		let beginImage = image
        return beginImage.rotate()
    }
	
	func mirrorFilter(image: UIImage) -> UIImage? {
        
		let beginImage = image
        return beginImage.withHorizontallyFlippedOrientation()
	}
	
	func invertFilter(image: UIImage) -> UIImage? {
        
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
