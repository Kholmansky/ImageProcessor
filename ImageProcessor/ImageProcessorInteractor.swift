//
//  ImageProcessor.swift
//  ImageProcessor
//
//  Created by IOS developer on 19/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit

class ImageProcessorInteractor: ImageProcessorInteractorProtocol {
    
    weak var presenter: ImageProcessorPresenterProtocol!
    
    required init(presenter: ImageProcessorPresenterProtocol) {
        self.presenter = presenter
    }
    
    
    func getImage() {
        
    }
    
    func loadImage() {
        
    }
    
    func chooseImage() {
        
    }
    
    func applyRotateFilter(image: UIImage) -> UIImage? {
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
    
    func applyMirrorFilter(image: UIImage) -> UIImage? {
        return image.withHorizontallyFlippedOrientation()
    }
    
    func applyInvertFilter(image:UIImage) -> UIImage? {
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
    
    func saveImage() {
        
    }
    
    func getImages() {
        
    }
    
    func insertImage() {
        
    }
    
    func deleteImage() {
        
    }
    

    
    
}
