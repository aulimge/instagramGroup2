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

    
    var fbloginID : String = ""
    
    
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
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else { return }
            
            //skip login page straight to homepage
            present(vc, animated:  true, completion:  nil)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapGesture)
        


       
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
        
        showEmailAddress()

        
        
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Someting went wrong with our FB User :", error ?? "")
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
            
            //later consider changing
            guard let id = user?.uid else {return}
            self.fbloginID = id
            
            //read from Firebase and check if FB Login already Created
//            let ref = Database.database().reference()
//            ref.child("Users").child(id).observe(.value, with: { (snapshot) in
//                if let name = snapshot.["name"] as? String {
            
            
         //       } else {
                    //Create New User in Database using FB details
                    self.fbSignUpCreateNewUser()
          //      }
         //   })
            

        

    }
    }
    
    func fbSignUpCreateNewUser() {
        //GEt Email Address from FB
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email"]).start { (connection, result, error) in
            
            if error != nil {
                print("Failed to start graph request:", error ?? "")
                return
            }
            
            if let info = result as? [String:Any],
                let name = info["name"] as? String,
                let email = info["email"] as? String,
                let firstName = info["first_name"] as? String,
                let lastName = info["last_name"] as? String {
                //let uid = info["id"] as? String {
 

                
                //save to FIRDatabase
                let ref = Database.database().reference()
                
                let post : [String:Any] = ["id": self.fbloginID ,"name": name, "email": email, "firstName": firstName,"lastName": lastName, "imageURL": "","imageFilename": ""]
                
                //ref.child("Users").child(uid).setValue(post)
                ref.child("Users").child(self.fbloginID).setValue(post)
                
                //self.navigationController?.popViewController(animated: true)
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else { return }
                
                //skip login page straight to homepage
                self.present(vc, animated:  true, completion:  nil)
                
                
                
            }
            
            print(result ?? "")
            
        }
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
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else { return }
                
                //if let Auth().currentUser?.uid = user

               // g_userId = Auth().currentUser?.uid
               // g_userName = ""
                
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


