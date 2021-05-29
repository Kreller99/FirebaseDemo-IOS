//
//  FirebaseService.swift
//  FirebaseDemo
//
//  Created by Christian Haugaard on 01/03/2021.
//

import Foundation
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

class FirebaseService {
    
    var notes = [Note]()
    private var notesCol = "notes"
    private var db = Firestore.firestore()
    var parent:Updateable?
    var storage = Storage.storage()
    var storageRef:StorageReference?
    private var imageURL = URL(string: "")
    var parent_view_controller: ViewController? = nil
    var detail: DetailViewController?
    var myImagePicker = ImagePicker()
    
    
    func saveNote(text: String) {
        print("Press")
        if text.count > 0 {
                let doc = db.collection(notesCol).document()
                var data = [String:String]()
                data["text"] = text
                doc.setData(data)
            }
    }
    
    
    func uploadImage(image: UIImage){
        //print("Method" + img)
        let imageNames = myImagePicker.imagePickerController1
        print("Testen", imageNames)
        myImagePicker.sourceType = .photoLibrary
            if let data = image.jpegData(compressionQuality: 1.0){
                print("First if statement")
                let imageRef = storageRef?.child("IMG_004")
                print("uploadImage called")
                imageRef?.putData(data, metadata: nil, completion: { (metadata, error) in
                    if let e = error {
                        print("error uploading image \(e)")
                    }else {
                        print("OK uploading image")
                    }
                })
            }
        }
    
    func downloadImage() {
        /*db.collection(images).addSnapshopListene{ (snap, error) in
            if let = error {
                print("error in fetching data (Image) \(e)")
            } else {
                if let s = snap {
                    
                }
            }*/
        
        let storageReferance = Storage.storage().reference(withPath: "john.jpg")
        
        storageReferance.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            self.imageURL = url!

        }
        

        
    }
    
    func startListener(){
        db.collection(notesCol).addSnapshotListener{ (snap, error) in
            if let e = error {
                print("error fetching data \(e)")
            } else {
                if let s = snap {
                    self.notes.removeAll()
                    for doc in s.documents {
                        if let txt = doc.data()["text"] as? String{
                            print(txt)
                            print(doc.documentID)
                            let note = Note(id: doc.documentID, text: txt)
                            self.notes.append(note)
                        }
                    }
                    self.parent?.update(obj: nil)
                }
            }
        }
    }
    
    func deleteNote(index: Int) {
        if index < notes.count{
            let docID = notes[index].id
                db.collection(notesCol).document(docID).delete() { err in
                    if let e = err {
                        print("error deleting \(docID) \(e)")
                    } else {
                        print("ok deleting \(docID)")
                    }
                }
            notes.remove(at: index)
        }
    }
    
    func updateNote(index: Int, text: String) {
        let docID = notes[index].id
        let doc = db.collection(notesCol).document(docID)
        var data = [String:String]()
        data["text"] = text
        doc.setData(data)
        
        //print("Press")
        //if text.count > 0 {
         //       let doc = db.collection(notesCol).document()
         //       var data = [String:String]()
         //       data["text"] = text
         //       doc.setData(data)
         //   }
    }
    
    
    
    
    
}
