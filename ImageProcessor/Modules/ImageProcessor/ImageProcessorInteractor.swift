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
    
    func applyFilter(filter: TypeOfFilter, for image: UIImage) -> UIImage? {
        return filter.apply(for: image)
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
    
	func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
