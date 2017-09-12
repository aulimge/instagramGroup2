//
//  LoginViewController.swift
//  Instagram_Group2
//
//  Created by Tan Wei Liang on 11/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtnTapped: UIButton!{
        didSet{
            loginBtnTapped.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Login Email
        if Auth.auth().currentUser != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else { return }
            
            //skip login page straight to homepage
            present(vc, animated:  true, completion:  nil)
        }
        
     
        


       
    }
    
    //******FB Login***************
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton! {
        didSet{
            fbLoginButton.delegate = self
            fbLoginButton.readPermissions = ["email","public_profile"]
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
         print("Did Logout of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with Facebook...")
    }
    
    
    
    
    //****Normal Email Login ********
    func loginUser() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if self.emailTextField.text == "" {
                self.createErrorAlert("Empty Email Text Field", "Plaese Input Valid Email")
                return
            }
            else if self.passwordTextField.text == "" {
                self.createErrorAlert("Empty Password Text Field", "Please Input Valid Password")
                return
            }
            if let validError = error {
                
                print(validError.localizedDescription)
                self.createErrorAlert("Error", validError.localizedDescription)
            }
            
            if let validUser = user {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else { return }
                
                self.present(vc, animated:  true, completion:  nil)
                
            }
            
        }
        
    }
    
    func createErrorAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Error", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)
        
    }

    

}



//extension LoginViewController : FBSDKLoginButtonDelegate {
//    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        
//        if error != nil {
//            print(error)
//            return
//        }
//        
//        let accessToken = FBSDKAccessToken.current()
//        if let accessTokenString = accessToken?.tokenString {
//            
//            //print("FBaccess token is \(accessTokenString)")
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
//            
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                if error != nil {
//                    print("Something wrong with the error user", error)
//                    return
//                }
//                
//                var ref: DatabaseReference()
//                let userAuth = Auth.auth().currentUser
//                let currentUserID : String = ""
//                
//                ref = Database.database().reference()
//                
//                if let id = userAuth?.uid {
//                    
//                }
//                
//                
//                
//                
//            })
//            
//        }
//        
//        
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("User logged out")
//    }
//    
//}


