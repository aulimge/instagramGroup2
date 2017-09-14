//
//  EditProfileViewController.swift
//  
//
//  Created by Tan Wei Liang on 14/09/2017.
//
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class EditProfileViewController: UIViewController {

    var selectedContact: Contact?
    var ref: DatabaseReference!
    var imageUrl: String = ""
    
    var userId : String = ""

   
    @IBOutlet weak var editBtnTapped: UIButton!{
        didSet {
            editBtnTapped.addTarget(self, action: #selector(editBtn), for: .touchUpInside)
        }

    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func uploadPhotoBtnTapped(_ sender: Any) {

         updateProfilePicEnable()
        
    }
    
    
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet {
            usernameTextField.isUserInteractionEnabled = false //keyboard will not come out when the user tappes on the keyboard
        }

    }
   
    @IBOutlet weak var firstNameTextField: UITextField!{
        didSet {
            firstNameTextField.isUserInteractionEnabled = false //keyboard will not come out when the user tappes on the keyboard
        }

    }
    @IBOutlet weak var lastNameTextField: UITextField!{
        didSet {
            lastNameTextField.isUserInteractionEnabled = false //keyboard will not come out when the user tappes on the keyboard
        }

    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        userId = uid
        
        guard let username = selectedContact?.username,
            let firstname = selectedContact?.fullname,
            let lastname = selectedContact?.fullname,
            let imageURL = selectedContact?.imageURL
            else {return}
        
        usernameTextField.text = username
        firstNameTextField.text = firstname
        lastNameTextField.text = lastname
      
        imageView.loadImage(from: imageURL)

        
    }

    func loadImage(urlString: String) {
        //1.url
        //2.session
        //3.task
        //4.start
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
    
    func updateProfilePicEnable() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func editBtn() {
        if editBtnTapped.titleLabel?.text == "Edit" {
            usernameTextField.isUserInteractionEnabled = true
            firstNameTextField.isUserInteractionEnabled = true
            lastNameTextField.isUserInteractionEnabled = true
            //updateProfilePicEnable() //Enable user to change profile pic
            editBtnTapped.setTitle("Done", for: .normal)
        } else {
            usernameTextField.isUserInteractionEnabled = false
            firstNameTextField.isUserInteractionEnabled = false
            lastNameTextField.isUserInteractionEnabled = false
            
            ref = Database.database().reference()
           
            //get the id of the specific user
            guard let username = usernameTextField.text,
                let firstname = firstNameTextField.text,
                let lastname = lastNameTextField.text
                else {return}
            
            let post : [String:Any] = ["firstName": firstname, "lastName":lastname, "imageURL": imageUrl]
            
            //dig path to the user
            ref.child("Users").child(userId).updateChildValues(post)

            
            //
            
            editBtnTapped.setTitle("Edit", for: .normal)
        }
        
        //navigationController?.popViewController(animated: true)
    }
    
    func uploadImageToStorage(_ image: UIImage) {
        let ref = Storage.storage().reference()
        
        let timeStamp = Date().timeIntervalSince1970
        
        //compress image so that the image isn't too big
        guard let imageData = UIImageJPEGRepresentation(image, 0.2) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        //metadata gives us the url to retrieve the data on the cloud
        
        ref.child("\(timeStamp).jpeg").putData(imageData, metadata: metaData) { (meta, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                self.imageUrl = downloadPath
                self.imageView.image = image
            }
        }
    }

    
   }

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            //no matter what happens, this will get executed
            dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        uploadImageToStorage(image)
        
        
    }
}

