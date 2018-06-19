//
//  ViewController.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 16/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import UIKit
import CoreData

class ImageProcessorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imagePicked: UIImageView!
	
	let imgProc = ImageProcessor.shared
	
	var images = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicked.backgroundColor = UIColor.lightGray
        tableView.dataSource = self
        tableView.delegate = self
		update()
    }
	
    @IBAction func showChoooseImageSource (_ sender: Any) {
		getImage()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		imagePicked.image = image
		dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyFilterTapped (_ sender: UIButton) {
		if let image = imagePicked.image {
			if let newImage = imgProc.applyFilter(image: image, filter: sender.tag) {
				saveImageToCoreData(image: newImage)
				update()
			}
		}
    }
	
	func update () {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest = Image.fetchRequest() as NSFetchRequest<Image>
		
		let sortDescriptor = NSSortDescriptor(key: "imageId", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]

		do {
			images = try context.fetch(fetchRequest)
		} catch let error {
			print ("Failed to load data due error: \(error).")
		}
		tableView.reloadData()
	}
	
	func getImage() {
		
		let alertController = UIAlertController(title: "Open image from...", message: nil, preferredStyle: .alert)
		
		alertController.addAction(UIAlertAction(title: "Camera", style: .default) {(action) in
			self.chooseImage(from: .camera)
		})
		alertController.addAction(UIAlertAction(title: "Library", style: .default) {(action) in
			self.chooseImage(from: .photoLibrary)
		})
		alertController.addAction(UIAlertAction(title: "URL", style: .default) {(action) in
			self.enterUrlAlert()
		})
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	func chooseImage(from source: UIImagePickerControllerSourceType) {
		if UIImagePickerController.isSourceTypeAvailable(source) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = source;
			imagePicker.allowsEditing = false
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
	
	func enterUrlAlert() {
		
		let alert = UIAlertController(title: "Enter image URL", message: nil, preferredStyle: .alert)
		
		alert.addTextField { (textField) in
			textField.placeholder = "image URL"
		}
		
		let downloadAction = UIAlertAction(title: "Download", style: .default) { (action) in
			if let text = alert.textFields?.first?.text {
				if (text != ""){
					self.imagePicked.load(url: URL(string: text)!)
				}
			}
		}
		alert.addAction(downloadAction)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func saveImageToCoreData (image: UIImage?) {
		
		//		var imageData: Data = UIImagePNGRepresentation(image)
		//		var imageUIImage: UIImage = UIImage(data: imageData)
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let newImageData: Data = UIImagePNGRepresentation(image)!
		let newImage = Image(context: context)
		newImage.imageData = newImageData
		newImage.imageId = UUID().uuidString
		
		if let uniqueId = newImage.imageId {
			print("imageId:\(uniqueId)")
		}
		
		do {
			
			try context.save()
			
		} catch let error{
			
			print("Failed to save due the error: \(error)")
		}
		
	}
	
	func saveImageToGallery(image: UIImage) {
		
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
        
        return images.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
		if images.count > indexPath.row {
			let image = images[indexPath.row]
			
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
			context.delete(image)
			images.remove(at: indexPath.row)
			do {
				try context.save()
			}catch let error {
				print("Failed to save due error: \(error).")
			}
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		let image = images[indexPath.row]
		let imageUIImage: UIImage = UIImage(data: image.imageData!)!
		cell.imageView?.image = imageUIImage
		return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let alertController = UIAlertController(title: "Hint", message: "What do you want to do with this image?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Save to photo library", style: .default){(action) in
                self.saveImageToGallery(image: (cell.imageView?.image)!)
            })
            alertController.addAction(UIAlertAction(title: "Reuse", style: .default){(acrion) in
                self.imagePicked.image = cell.imageView?.image
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

