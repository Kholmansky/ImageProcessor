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
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    @IBAction func getImageButtonClicked(_ sender: UIButton) {
        presenter.getImageButtonClicked()
    }
    
    @IBAction func mirrorImageButtonClicked(_ sender: UIButton) {
        presenter.mirrorImageButtonClicked()
    }
    
    @IBAction func rotateImageButtonClicked(_ sender: UIButton) {
        presenter.rotateImageButtonClicked()
    }
    
    @IBAction func invertImageButtonclicked(_ sender: UIButton) {
        presenter.invertImageButtonClicked()
    }
    
}

extension ImageProcessorViewController: ImageProcessorViewProtocol {
    func showChooseImageDataProvider() {
        
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
    
    func update() {
        
    }
    
    func setInputImage(image: UIImage) {
        
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
            //self.presenter.tapReuseImage(at: index)
        }
        alertController.addAction(reuseAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showError(at message: String) {
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
            imagePicked.image = image
        } else {
            showError(at: "Ooooops...")
        }
        self.dismiss(animated: true, completion: nil)
    }
}



extension ImageProcessorViewController: UITableViewDataSource, UITableViewDelegate {
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.imageHistoryCount()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        presenter.swipeToDeleteImage(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let imageUIImage = presenter.getImage(at: indexPath.row)
        cell.imageView?.image = imageUIImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let alertController = UIAlertController(title: "Hint", message: "What do you want to do with this image?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Save to photo library", style: .default){(action) in
                //self.saveImageToGallery(image: (cell.imageView?.image)!)
            })
            alertController.addAction(UIAlertAction(title: "Reuse", style: .default){(acrion) in
               // self.imagePicked.image = cell.imageView?.image
            })
            //self.present(alertController, animated: true, completion: nil)
        }
    }
}

    











