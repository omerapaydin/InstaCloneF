//
//  EditController.swift
//  InstaCloneF
//
//  Created by Ömer on 29.09.2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class EditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var editImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        editImage.addGestureRecognizer(tapGesture)
     
        
    }
    
    @objc func tapImage(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        editImage.image = info[.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
   
    
    @IBAction func back(_ sender: Any) {
        
        
        userLabel.text = ""
        editImage.image = UIImage(named: "select")
        performSegue(withIdentifier: "goProfile", sender: nil)
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolerRef = storageRef.child("media")
        
        if let data = editImage.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolerRef.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                
               if error == nil {
                   imageRef.downloadURL { (url, error) in
                       
                       if error == nil {
                           
                           let imageURL = url?.absoluteString
                           
                           let firebaseDatabase = Firestore.firestore()
                           
                           var firestoneReferance : DocumentReference? = nil
                           
                           let newData : [String:Any] = ["imageURL":imageURL,"userName":self.userLabel.text,"date":FieldValue.serverTimestamp()] as [String : Any]
                           
                           
                           firestoneReferance = firebaseDatabase.collection("Users").addDocument(data: newData, completion: { (error) in
                               
                               if error != nil {
                                   print(error?.localizedDescription ?? "error")
                               }else{
                                   
                                   self.editImage.image = UIImage(named:"select")
                                   self.userLabel.text = ""
                                   self.performSegue(withIdentifier: "goProfile", sender: nil)
                                   
                               }
                               
                               
                               
                               
                           })
                           
                           
                           
                           
                       }else {
                           print(error?.localizedDescription ?? "error")
                       }
                       
                   }
                   
                   
               }else{
                   print(error?.localizedDescription ?? "error")
               }
                
               
            }
       
        }
        
        
        
        
        
        
        
    }
    
}
