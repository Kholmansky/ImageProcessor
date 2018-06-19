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
	
	func rotateFilter(image: UIImage?) -> UIImage? {
		if let beginImage = image {
			return beginImage.rotate()
		}
		return nil
	}
	
	func mirrorFilter(image: UIImage?) -> UIImage? {
		if let beginImage = image {
			return beginImage.withHorizontallyFlippedOrientation()
		}
		return nil
	}
	
	func invertFilter(image: UIImage?) -> UIImage? {
		if let beginImage = image {
			if let inputImage = CIImage(image: beginImage) {
				if let filter = CIFilter(name: "CIPhotoEffectMono") {
					filter.setValue(inputImage, forKey: kCIInputImageKey)
					let newImage = UIImage(ciImage: filter.outputImage!)
					return newImage
				}
			}
		}
		return nil
	}
	

}
