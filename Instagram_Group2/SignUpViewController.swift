//
//  SignUpViewController.swift
//  Instagram_Group2
//
//  Created by Tan Wei Liang on 11/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    
    @IBOutlet weak var createBtnTapped: UIButton!{
    
        didSet{
        
         createBtnTapped.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
    
    }
    
    func signUp() {
        
       
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let userName = usernameTextField.text
            
            else {return}
        
        
        if password != confirmPassword {
            createErrorVC("Password Error", "Password does not match")
        } else if email == "" || password == "" || confirmPassword == "" {
            createErrorVC("Missing input fill", "Please fill up your info appropriately in the respective spaces.")
        }
        
       
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.createErrorVC("Error", error.localizedDescription)
            }
            
            if let validUser = user {
                let ref = Database.database().reference()
                
               // let post : [String:Any] = ["email": email, "name": userName]
                let post : [String:Any] = ["name": userName, "email": email, "firstName": "" ,"lastName": "", "imageURL": "","imageFilename": ""]
                
                ref.child("Users").child(validUser.uid).setValue(post)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func createErrorVC(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

   
}


