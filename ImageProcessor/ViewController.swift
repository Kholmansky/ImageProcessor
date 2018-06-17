//
//  ViewController.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 16/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicked.backgroundColor = UIColor.lightGray
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private var history: [UIImage] = []
    
    func showChoooseImageSource () {
        
        let alertController = UIAlertController(title: "Open image from...", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default) {(action) in
            self.chooseImageFromCamera()
        })
        alertController.addAction(UIAlertAction(title: "Library", style: .default) {(action) in
            self.chooseImageFromLibrary()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }

    func chooseImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func chooseImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func chooseImageFrom(_ sender: Any) {
        
        showChoooseImageSource()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rotateImage(_ sender: Any) {
        
        if let beginImage = imagePicked.image {
            let newImage = beginImage.rotate()
            history.insert(newImage, at: 0)
            tableView.reloadData()
        }
    }
    
    @IBAction func invertColorsImage(_ sender: Any) {
        if let beginImage = imagePicked.image {
            if let inputImage = CIImage(image: beginImage) {
                if let filter = CIFilter(name: "CIPhotoEffectMono") {
                    filter.setValue(inputImage, forKey: kCIInputImageKey)
                    let newImage = UIImage(ciImage: filter.outputImage!)
                    history.insert(newImage, at: 0)
                    tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func mirrorImage(_ sender: Any) {
        
        if let beginImage = imagePicked.image {
            let newImage = beginImage.withHorizontallyFlippedOrientation()
            history.insert(newImage, at: 0)
            tableView.reloadData()
        }
    }
    
    
    func saveImage(image: UIImage) {
        
        let imageData = UIImagePNGRepresentation(image)
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return history.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        if history.count > indexPath.row {
            history.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let image = history[indexPath.row]
        cell.imageView?.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let alertController = UIAlertController(title: "Hint", message: "What do you want to do with this image?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Save to photo library", style: .default){(action) in
                self.saveImage(image: (cell.imageView?.image)!)
            })
            alertController.addAction(UIAlertAction(title: "Reuse", style: .default){(acrion) in
                self.imagePicked.image = cell.imageView?.image
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

