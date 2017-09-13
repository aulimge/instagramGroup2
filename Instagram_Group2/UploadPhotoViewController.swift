//
//  UploadPhotoViewController.swift
//  Instagram_Group2
//
//  Created by Tan Wei Liang on 12/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UploadPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    var profilePicURL : String = ""
    var imageFilename : String = ""
    
    //delegate var recv
    var userId : String = ""
    var userName : String = ""

    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get User Id
        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        userId = uid
        
        userName = "audrey"
       
        
        picker.delegate = self
    }
    
    @IBAction func buttonUpload(_ sender: UIBarButtonItem) {
        
        //photo From Library
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
        
    }
    
    @IBAction func buttonCamera(_ sender: UIBarButtonItem) {
        
        //shoot camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
//            picker.supportedInterfaceOrientations = [UIInterfaceOrientationMask.portrait]
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
        
    }
    
@IBAction func saveButton(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: title, message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Image Uploaded", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)

       //save the ImageURL to posts
        ref = Database.database().reference()
 
    
        let post : [String:Any] = ["caption" : "Hello there", "id": self.userId ,"username": self.userName, "isLiked": false, "likeCount": 0,"likes": "", "imageURL": profilePicURL,"imageFilename": imageFilename]
    
        let randomID = String(Int(Date().timeIntervalSince1970))
    
    
        ref.child("Posts").child(randomID).setValue(post)
    
    
} //saveButton
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func uploadToStorage(_ image: UIImage) {
        
        let ref = Storage.storage().reference()
        
        let timeStamp = Date().timeIntervalSince1970
        guard let imageData = UIImageJPEGRepresentation(image, 0.2) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageFilename = "\(timeStamp).jpeg"
        
        ref.child("\(timeStamp).jpeg").putData(imageData, metadata: metaData) { (meta, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validMeta = meta,
                let downloadPath = meta?.downloadURL()?.absoluteString{
                self.profilePicURL = downloadPath
                self.imageView.image = image
                
                self.profilePicURL = downloadPath
            }
        }
    }

    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit //3
        imageView.image = chosenImage //4
        //dismiss(animated:true, completion: nil) //5
        
        
        defer {
            dismiss(animated:true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        
        uploadToStorage(image)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

