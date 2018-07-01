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
    var imagesInTableView = [DisplayedImage]()
    
    required init (view: ImageProcessorViewProtocol) {
        self.view = view
    }
	
	func configureView() {
        imageHistory = interactor.getAllImages()
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
    
    func applyFilterClicked(filter: String) {
        if let image = inputImage {
            let newImage: UIImage?
            
            switch filter {
            case "Rotate":
                newImage = interactor.applyRotateFilter(image: image)
            case "Mirror":
                newImage = interactor.applyMirrorFilter(image: image)
            case "Invert":
                newImage = interactor.applyInvertFilter(image: image)
            default:
                return
            }
            interactor.saveImageToHistory(newImage)
            configureView()
        }
        
    }
    
    func selectFilteredImage(at index: Int) {
        view.showWhatToDoWithResult(at: index)
    }
    
    func tapSaveImageToGallery(at index: Int) {
		interactor.saveImage(getImage(at: index) )
    }
    
    func tapUseImage(at index: Int) {
        let image = getImage(at: index)
        loadImage(image: image)
    }
    
    func tapDeleteImage(at index: Int) {
        if imageHistory.count > index {
            let image = imageHistory[index]
            imageHistory.remove(at: index)
            interactor.removeImageFromHistory(image)
        }
    }
    
    func getImage(at index: Int) -> UIImage {
        let image = imageHistory[index]
        return UIImage(data: image.imageData!)!
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
	
	func selectDownloadImage() {
		view.showInputUrlAlert()
	}
}
