//
//  ProfileController.swift
//  InstaCloneF
//
//  Created by Ömer on 28.09.2024.
//

import UIKit
import FirebaseAuth
import Firebase
import SDWebImage
import SDWebImageMapKit

class ProfileController: UIViewController {

    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
    }
    
    
    
    func getData(){
        
        
        let database = Firestore.firestore()
        
        database.collection("Users").order(by: "date").addSnapshotListener { (snapshot, error) in
            
            if snapshot?.isEmpty != true && snapshot != nil{
                
               
                
                let lastDocument = snapshot?.documents.last
                
              
                    
                   if let userName = lastDocument?.get("userName") as? String {
                       self.userText.text = userName
                   }
                   
                   if let image = lastDocument?.get("imageURL") as? String {
                       self.imageView.sd_setImage(with: URL(string: image))
                   }
                
                
                
                
            }else {
                self.imageView.image = UIImage(named: "select")
                self.userText.text = "@..."
            }
            
            
        }
        
        
        
    }
    
    
   
    @IBAction func signOut(_ sender: Any) {
        
        
        do {
            
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "goTo2", sender: nil)
            
        }catch {
            print("error")
            
        }
        
    }
    
    
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "goEdit", sender: nil)
    }
    
    
}
