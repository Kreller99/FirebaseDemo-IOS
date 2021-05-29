//
//  ImagePicker.swift
//  FirebaseDemo
//
//  Created by Christian Haugaard on 08/03/2021.
//

import Foundation
import UIKit

class ImagePicker: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parentVC: Updateable?
    
    override func viewDidLoad() {
        super.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("back with an image \(info.description)")
        if let img = info[.originalImage] as? UIImage{
            parentVC?.update(obj: img)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController1(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL else { return }
        print(fileUrl.lastPathComponent)
        
    }
}
