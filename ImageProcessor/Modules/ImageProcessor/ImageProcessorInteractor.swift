//
//  ImageProcessor.swift
//  ImageProcessor
//
//  Created by IOS developer on 19/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit
import CoreData

class ImageProcessorInteractor: ImageProcessorInteractorProtocol {
    
    weak var presenter: ImageProcessorPresenterProtocol!
    
    required init(presenter: ImageProcessorPresenterProtocol) {
        self.presenter = presenter
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
        UIGraphicsBeginImageContext(image.size)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: image.size.width, y: image.size.height)
        bitmap.scaleBy(x: -image.scale, y: -image.scale)
        bitmap.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
    
    func saveImageToHistory(_ image: UIImage?) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let date = Date()
        
        if let newImageData: Data = UIImagePNGRepresentation(image!){
            let newImage = Image(context: context)
            newImage.imageData = newImageData
            newImage.imageId = UUID().uuidString
            newImage.imageDate = date
            
            if let uniqueId = newImage.imageId {
                print("imageId:\(uniqueId)")
            }
        }
        do {
            try context.save()
        } catch let error{
            print("Failed to save due the error: \(error)")
        }
    }
    
    func removeImageFromHistory(_ image: NSManagedObject) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(image)
        do {
            try context.save()
        }catch let error {
            print("Failed to save due error: \(error).")
        }

    }
    
    func getAllImages() -> [Image] {
        
        var savedImages = [Image]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Image.fetchRequest() as NSFetchRequest<Image>
        
        let sortDescriptor = NSSortDescriptor(key: "imageDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            savedImages = try context.fetch(fetchRequest)
        } catch let error {
            print ("Failed to load data due error: \(error).")
        }
        return savedImages
    }
    
    func getImage(by index: Int){
        
    }
    
	func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
