//
//  ImageProcessorView.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 28/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit
import CoreData

class ImageProcessorPresenter: ImageProcessorPresenterProtocol {

    weak var view: ImageProcessorViewProtocol!
    var interactor: ImageProcessorInteractorProtocol!
    var inputImage: UIImage?
    var imageHistory = [Image] ()
    
    required init (view: ImageProcessorViewProtocol) {
        self.view = view
    }
	
	func configureView() {
		getAllImages()
		view.update()
	}
	
	func loadImage(image: UIImage) {
		inputImage = image
		view.setInputImage(image: inputImage!)
	}
    
    func selectImageDataProvider(at type: UIImagePickerControllerSourceType) {
        view.showImagePickerController(at: type)
    }
    
    func imageHistoryCount() -> Int {
        return imageHistory.count
    }
    
    func rotateImageButtonClicked() {
        if let image = inputImage {
            let newImage = interactor.applyRotateFilter(image: image)
            saveImageToCoreData(image: newImage)
			view.update()
        }
    }
    
    func mirrorImageButtonClicked() {
        if let image = inputImage {
            let newImage = interactor.applyMirrorFilter(image: image)
            saveImageToCoreData(image: newImage)
			view.update()
        }
    }
    
    func invertImageButtonClicked() {
        if let image = inputImage {
            let newImage = interactor.applyInvertFilter(image: image)
            saveImageToCoreData(image: newImage)
			view.update()
        }
    }
    
    func selectFilteredImage(at index: Int) {
        view.showWhatToDoWithResult(at: index)
    }
    
    func tapSaveImageToGallery(at index: Int) {
		interactor.saveImage(getImage(at: index) )
    }
    
    func tapUseImage(at index: Int) {
        loadImage(image: getImage(at: index))
    }
    
    func tapDeleteImage(at index: Int) {
        swipeToDeleteImage(at: index)
    }
    
    func getImage(at index: Int) -> UIImage {
        let image = imageHistory[index]
		print (UIImage(data: image.imageData!)!)
        return UIImage(data: image.imageData!)!
    }
    
    func swipeToDeleteImage(at index: Int) {
        
        if imageHistory.count > index {
            let image = imageHistory[index]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(image)
            imageHistory.remove(at: index)
            do {
                try context.save()
            }catch let error {
                print("Failed to save due error: \(error).")
            }
            
        }
    }
    
    func getImageButtonClicked() {
        view.showChooseImageFrom()
    }
	
	func downloadImage(from url_str: String) {
		let url:URL = URL(string: url_str)!
		let session = URLSession.shared
		
		let task = session.dataTask(with: url, completionHandler: {
			(data, response, error) in
			
			if data != nil {
				let image = UIImage(data: data!)
				if(image != nil) {
					DispatchQueue.main.async(execute: {
						self.loadImage(image: image!)
					})
				}
			}
		})
		task.resume()
	}
	
	func getAllImages() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = Image.fetchRequest() as NSFetchRequest<Image>
		
		let sortDescriptor = NSSortDescriptor(key: "imageDate", ascending: false)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		do {
			imageHistory = try context.fetch(fetchRequest)
		} catch let error {
			print ("Failed to load data due error: \(error).")
		}
		
	}
	
	func selectDownloadImage() {
		view.showInputUrlAlert()
	}
	
    func saveImageToCoreData (image: UIImage?) {
        
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
}
