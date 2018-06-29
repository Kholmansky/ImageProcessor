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
    func showChooseImageDataProvider()
    func update()
    func showImagePickerController (at type: UIImagePickerControllerSourceType)
    func showInputUrlAlert()
    func showWhatToDoWithResult(at index: Int)
}

protocol ImageProcessorPresenterProtocol: class {
    func configureView()
    func getImageButtonClicked()
    func selectImageDataProvider(at type: UIImagePickerControllerSourceType)
    
    func rotateImageButtonClicked()
    func mirrorImageButtonClicked()
    func invertImageButtonClicked()
    func selectFilteredImage(at index: Int)
    func tapSaveImageToGallery(at index: Int)
    func tapReuseImage()
    func tapDeleteImage(at index: Int)
    func swipeToDeleteImage(at index: Int)
    func getAllImages()
    func getImage(at index: Int) -> UIImage
    func selectDownloadImage()
    func imageHistoryCount() -> Int

}

protocol ImageProcessorInteractorProtocol: class {
    func getImage()
    func loadImage()
    func chooseImage()
    func applyRotateFilter(image: UIImage) -> UIImage?
    func applyMirrorFilter(image: UIImage) -> UIImage?
    func applyInvertFilter(image: UIImage) -> UIImage?
    func saveImage()
    func getImages()
    func insertImage()
    func deleteImage()
}

protocol ImageProcessorConfiguratorProtocol: class {
    func configure (with viewController: ImageProcessorViewController)
}
