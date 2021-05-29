//
//  DetailViewController.swift
//  FirebaseDemo
//
//  Created by Christian Haugaard on 08/03/2021.
//

import UIKit

class DetailViewController: UIViewController, Updateable {
    func update(obj: NSObject?) {
        if let img = obj as? UIImage{
            imageView.image = img
        }
    }
    

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var myImagePicker = ImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImagePicker.parentVC = self

    }
    
    
    @IBAction func photoLibPressed(_ sender: UIButton) {
        myImagePicker.sourceType = .photoLibrary
        present(myImagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func saveImageFIRPressed(_ sender: Any) {
        
        if let img = imageView.image {
            fs.uploadImage(image: img)
        }
        
        
    }
    
}
