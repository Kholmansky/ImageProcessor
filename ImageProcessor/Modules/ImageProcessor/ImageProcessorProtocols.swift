//
//  ImageProcessorProtocols.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 28/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit
import CoreData

protocol ImageProcessorViewProtocol: class {
    func setInputImage(image: UIImage)
    func showChooseImageFrom()
    func update()
    func showImagePickerController (at type: UIImagePickerControllerSourceType)
    func showInputUrlAlert()
    func showWhatToDoWithResult(at index: Int)
}

protocol ImageProcessorPresenterProtocol: class {
    func configureView()
    func getImageButtonClicked()
    func selectImageDataProvider(at type: UIImagePickerControllerSourceType)
	func loadImage(image: UIImage)
    func applyFilterClicked(filter: TypeOfFilter) 
    func selectFilteredImage(at index: Int)
    func tapSaveImageToGallery(at index: Int)
	func tapUseImage(at index: Int)
    func tapDeleteImage(at index: Int)
    func getImage(at index: Int) -> UIImage
    func selectDownloadImage()
    func imageHistoryCount() -> Int
	func downloadImage(from url_str: String)
}

protocol ImageProcessorInteractorProtocol: class {
    func applyFilter(filter: TypeOfFilter, for image: UIImage) -> UIImage?
    func saveImageToHistory(_ image: UIImage?)
    func getAllImages() -> [Image]
    func removeImageFromHistory(_ image: NSManagedObject)
	func saveImage(_ image: UIImage)
}

protocol ImageProcessorConfiguratorProtocol: class {
    func configure (with viewController: ImageProcessorViewController)
}
