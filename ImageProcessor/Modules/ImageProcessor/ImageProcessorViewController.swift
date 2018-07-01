//
//  ViewController.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 16/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit

class ImageProcessorViewController: UIViewController {

    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var historyTableView: UITableView!
    
    var presenter: ImageProcessorPresenterProtocol!
    var configurator: ImageProcessorConfiguratorProtocol = ImageProcessorConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		imagePicked.backgroundColor = UIColor.gray
        
		historyTableView.dataSource = self
		historyTableView.delegate = self
        
        configurator.configure(with: self)
		presenter.configureView()
    }
    
    @IBAction func getImageButtonClicked(_ sender: UIButton) {
        presenter.getImageButtonClicked()
    }
    
    @IBAction func mirrorImageButtonClicked(_ sender: UIButton) {
        presenter.applyFilterClicked(filter: "Mirror")
    }
    
    @IBAction func rotateImageButtonClicked(_ sender: UIButton) {
        presenter.applyFilterClicked(filter: "Rotate")
    }
    
    @IBAction func invertImageButtonclicked(_ sender: UIButton) {
        presenter.applyFilterClicked(filter: "Invert")
    }
    
}

extension ImageProcessorViewController: ImageProcessorViewProtocol {
	
	func setInputImage(image: UIImage) {
		imagePicked.image = image
	}
	
	func update() {
		historyTableView.reloadData()
	}
    
    func deleteRows(at indexPath: IndexPath){
        historyTableView.deleteRows(at: [indexPath], with: .fade)
    }
	
    func showChooseImageFrom() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.presenter.selectImageDataProvider(at: .camera)
        }
        alertController.addAction(photoAction)
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            self.presenter.selectImageDataProvider(at: .photoLibrary)
        }
        alertController.addAction(libraryAction)
        
        let loadAction = UIAlertAction(title: "Download image", style: .default) { (action) in
            self.presenter.selectDownloadImage()
        }
        alertController.addAction(loadAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
	
    func showImagePickerController(at type: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = type
        if type == .camera {
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.videoQuality = .typeHigh
            imagePickerController.showsCameraControls = true
        }
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func showInputUrlAlert() {
		let alert = UIAlertController(title: "Enter image URL", message: nil, preferredStyle: .alert)
	
		alert.addTextField { (textField) in
			textField.placeholder = "image URL"
		}
		
		let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
			if let text = alert.textFields?.first?.text {
				self.presenter.downloadImage(from: text)
			}
		}
		alert.addAction(okAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		
		self.present(alert, animated: true, completion: nil)
    }
    
    func showWhatToDoWithResult(at index: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            self.presenter.tapSaveImageToGallery(at: index)
        }
        alertController.addAction(saveAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.presenter.tapDeleteImage(at: index)
        }
        alertController.addAction(deleteAction)
        
        let reuseAction = UIAlertAction(title: "Reuse", style: .default) { (action) in
			self.presenter.tapUseImage(at: index)
        }
        alertController.addAction(reuseAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorMessage(at message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}

extension ImageProcessorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            presenter.loadImage(image: image)
        } else {
            showErrorMessage(at: "Error in getting image ")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageProcessorViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.imageHistoryCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let image = presenter.getImage(at: indexPath.row)
		cell.imageView?.image = image
		return cell
	}
}

extension ImageProcessorViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.selectFilteredImage(at: indexPath.row)
	}
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        presenter.tapDeleteImage(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}











