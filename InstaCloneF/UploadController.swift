//
//  UploadController.swift
//  InstaCloneF
//
//  Created by Ömer on 28.09.2024.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class UploadController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageView.addGestureRecognizer(tapGesture)
        
        
        
    }
    func makeAlert(titleInput:String , messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @objc func handleTap() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true)
    }
    

    @IBAction func save(_ sender: Any) {
        
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                
                if let error {
                    
                    print("Error uploading image: \(error)")
                    
                }else {
                    
                    
                    imageRef.downloadURL { (url, error) in
                        
                        if error == nil {
                            let imageurl = url?.absoluteString
                            
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoneReferance : DocumentReference? = nil
                            
                            let postData = ["imageUrl" : imageurl,"posteBy": Auth.auth().currentUser?.email, "comment" : self.comment.text, "date":FieldValue.serverTimestamp(), "like":0 ] as [String : Any]
                            
                            
                            firestoneReferance = firestoreDatabase.collection("Posts").addDocument(data: postData, completion: { (error) in
                                
                                if error != nil {
                                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                                }else{
                                    
                                    self.imageView.image = UIImage(named:"select")
                                    self.comment.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                                
                                
                            })
                            
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
}
