//
//  ImageProcessorProtocols.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 28/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import Foundation
import UIKit

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
    func rotateImageButtonClicked()
    func mirrorImageButtonClicked()
    func invertImageButtonClicked()
    func selectFilteredImage(at index: Int)
    func tapSaveImageToGallery(at index: Int)
	func tapUseImage(at index: Int)
    func tapDeleteImage(at index: Int)
    func swipeToDeleteImage(at index: Int)
    func getAllImages()
    func getImage(at index: Int) -> UIImage
    func selectDownloadImage()
    func imageHistoryCount() -> Int
	func downloadImage(from url_str: String)
}

protocol ImageProcessorInteractorProtocol: class {
    func applyRotateFilter(image: UIImage) -> UIImage?
    func applyMirrorFilter(image: UIImage) -> UIImage?
    func applyInvertFilter(image: UIImage) -> UIImage?
	func saveImage(_ image: UIImage)
}

protocol ImageProcessorConfiguratorProtocol: class {
    func configure (with viewController: ImageProcessorViewController)
}
