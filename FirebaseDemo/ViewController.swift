//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Christian Haugaard on 22/02/2021.
//

import UIKit

import Firebase


let fs = FirebaseService() // will be visible across all classes

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Updateable {
    
    func update(obj: NSObject?) {
        tableView.reloadData()
        if let img = obj as? UIImage{
            imageView.image = img
        }
    }

    
    
    private var db = Firestore.firestore()
    
    @IBOutlet weak var updateField: UITextField!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var myImagePicker = ImagePicker()
    
    //private var notes = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fs.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = String(fs.notes[indexPath.row].text.prefix(15))
        return cell
        var len = fs.notes.count
        for s in Int(len) {
            print("Hejsa")
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("edit called \(indexPath.row)")
        fs.deleteNote(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you clicked on row \(indexPath.row)")
        currentIndex = indexPath.row
        updateField.text = fs.notes[indexPath.row].text
        performSegue(withIdentifier: "seque1", sender: self)
    }
    
    var currentIndex = 0
    @IBAction func updateNote(_ sender: Any) {
        fs.updateNote(index: currentIndex, text: updateField.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImagePicker.parentVC = self
        fs.parent = self
        fs.storageRef = fs.storage.reference()
        fs.startListener()
        tableView.delegate = self
        tableView.dataSource = self
        myImagePicker.sourceType = .photoLibrary
        //let storageReferance = Storage.storage().reference(withPath: imageView.image!.description)
        imageView.image = UIImage(contentsOfFile: "IMG_004")
        if let img = UIImage(named: "IMG_004") {
            print("OK image")
            fs.uploadImage(image: img)
        } else {
            print("Bad image")
        }
        let photo = fs.storageRef?.child("IMG_004")
        photo?.getData(maxSize: 1 * 1920 * 1080) { data, error in if error != nil{} else {
            let image = UIImage(data: data!)
            self.imageView.image = image
        }
            
        }
        
    }
    
        
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("Press")
        if let txt = textField.text {
            fs.saveNote(text: txt)
        }
        
        //if let txt = textField.text {
          //  if txt.count > 0 {
            //    let doc = db.collection("notes").document()
              //  var data = [String:String]()
                //data["text"] = textField.text
                //doc.setData(data)
            //}
        //}
    }
    
    @IBAction func photoLibPressed(_ sender: UIButton) {
        myImagePicker.sourceType = .photoLibrary
        present(myImagePicker, animated: true)
    }
    
    func update(obj: NSObject) {
        tableView.reloadData()
    
    }
    

    //@IBAction func updateNote(_ sender: UIButton) {
    //    fs.updateNote(index: , text: updateField.text!)
    //}
    
}

