//
//  ViewController.swift
//  InstaCloneF
//
//  Created by Ömer on 28.09.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signIn(_ sender: Any) {
           
           if emailText.text != "" && passwordText.text != "" {
               
               Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                   
                   if error != nil {
                       self.makeAlert(title: "Username/Password Error", message: error?.localizedDescription ?? "")
                   }else {
                       self.performSegue(withIdentifier: "goTo", sender: nil)
                   }
                   
               }
               
               
           }else {
               self.makeAlert(title: "Username/Password Error", message: "error")
           }
       }

       
       
       @IBAction func signUp(_ sender: Any) {
           
           if emailText.text != "" && passwordText.text != "" {
                   
               Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) {(authdata, error) in
                   
                   if error != nil {
                       self.makeAlert(title: "Username/Password Error", message: error?.localizedDescription ?? "")
                   } else {

                       self.performSegue(withIdentifier: "goTo", sender: nil)
                       
                   }
                   
               }
               
           }
           else {
               makeAlert(title: "Username/Password Error", message: "Please enter a username and password")
           }
       }
       
    
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

