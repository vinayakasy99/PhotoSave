//
//  ViewController.swift
//  PhotoSave
//
//  Created by vinayaka s yattinahalli on 12/01/21.
//  Copyright © 2021 vinayaka s yattinahalli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate  {
    
    @IBOutlet weak var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Take image
    @IBAction func takePhoto(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getDirectoryPath() -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Delivered")
        let url = NSURL(string: path)
        return url!
    }
    
    func getImageFromDocumentDirectory() {
        let fileManager = FileManager.default
        for i in 0..<1 {
            let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("Test.jpg")
            let urlString: String = imagePath!.absoluteString
            if fileManager.fileExists(atPath: urlString) {
                let image = UIImage(contentsOfFile: urlString)
               // imageArray.append(image!)
                imageTake.image = image
            } else {
                 print("No Image")
            }
        }
    }
    
    
    func configureDirectory() -> String {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Delivered")
        if !FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
}

extension ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        saveImageDocumentDirectory(image: selectedImage, imageName: "Test.jpg")
        
    }
    
    func saveImageDocumentDirectory(image: UIImage, imageName: String) {

        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("Test.jpg")
            let image = image
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                try imageData.write(to: fileURL)
            }
        } catch {
            print(error)
        }
        getImageFromDocumentDirectory()
    }
    
}
