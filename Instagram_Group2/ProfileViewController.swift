//
//  ProfileViewController.swift
//  Instagram_Group2
//
//  Created by Habib Zarrin Chang Fard on 12/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UIViewController {

    var selectedContact : Contact?
    var ref : DatabaseReference!
    var idEdit : Bool = true
    var posts: [Post] = []
    var contacts : [Contact] = []
    var profilePicURL : String = ""
    
    var totalpost = 0
    
    var userId : String = ""
    var userName : String = ""
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        collectionVIew.dataSource = self
        collectionVIew.delegate = self
        
        fetchPost()
        fetchHeader()
        //self.collectionVIew.reloadData()
        
        self.title = "audrey"   //userName

        
    }
    
    func fetchHeader() {
        //Get User Id
        ref = Database.database().reference()
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        //userId = uid
        //ref.child("Users").queryOrdered(byChild: "id").queryEqual(toValue: userId).observe(.value, with: { (snapshot) in
            
            
            
        ref.child("Users").child(userId).observe(.value, with: { (snapshot) in
            
            guard let info = snapshot.value as? [String: Any] else {return}
            
            //cast snapshot.value to correct Datatype
            if let p_username = info["name"] as? String,
                let firstname = info["firstName"] as? String,
                let lastname = info["lastName"] as? String,
                let email = info["email"] as? String,
                let imageURL = info["imageURL"] as? String,
                let filename = info["imageFilename"] as? String {
                
                
                let fullname =  "\(firstname) \(lastname)"
                //create new contact object
                let newContact = Contact(anID: snapshot.key, aUsername: p_username, aFullname: fullname, anEmail: email, anImageURL: imageURL, anFilename: filename)
                
                print(newContact)
                
                
                self.userName = p_username
                //append to contact array
                self.contacts.append(newContact)
                
                //self.collectionVIew.reloadData()
                //insert indv rows as we retrive idv items
                
                let  index = self.contacts.count - 1
                let indexPath = IndexPath(row: index, section: 0)
                self.collectionVIew.insertItems(at: [indexPath])
            
            }
            
        })

    }
    
    
    func fetchPost() {
        //Get User Id
        ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        userId = uid
        
 
        
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            
            guard let info = snapshot.value as? [String: Any] else {return}
            
            if let caption = info["caption"] as? String,
                let imageURL = info["imageURL"] as? String,
                let imageFileName = info["imageFilename"] as? String,
                let id = info["id"] as? String,
                let likeCount = info["likeCount"] as? Int,
                let isLiked = info["isLiked"] as? Bool,
                let p_username = info["username"] as? String
                
            {
                
                let newPost = Post(aCaption: caption, aImageURL: imageURL, aImageFilename: imageFileName, anId: id, aLikeCount: likeCount, aLikes: nil, anIsLiked: isLiked, anUsername: p_username)
                print(newPost)
                
                
                if imageURL != "" {
                    self.posts.append(newPost)
                    print(snapshot.value)
                    let  index = self.posts.count - 1
                    let indexPath = IndexPath(row: index, section: 1)
                    self.collectionVIew.insertItems(at: [indexPath])
                }
              //  let  index1 = self.contacts.count - 1
              //  let indexPath1 = IndexPath(row: index1, section: 0)
              //  self.collectionVIew.reloadItems(at: [indexPath1])
                
            }
            
            //self.collectionVIew.reloadData()
            
            
            
        })
 
    } //end FetchData
    
    
} // end ProfileViewController

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return contacts.count
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let headerViewCell = collectionVIew.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
            
            headerViewCell.labelUser.text = contacts[indexPath.row].username     //selectedContact?.fullname
            
            let imageURL = contacts[indexPath.row].imageURL
            headerViewCell.profileImageView.loadImage(from: imageURL)
            
            
            
           // if let imageurl = selectedContact?.imageURL {
            
            //headerViewCell.profileImageView.sd_setImage(with: URL(string: imageurl))
            headerViewCell.labelPost.text = String(posts.count)

            //}
            
            return headerViewCell

        } else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCollectionCell", for: indexPath) as! PictureCollectionViewCell
            cell.post = posts[indexPath.row]
            
            //let imageURL = contacts[indexPath.row].imageURL
            //headerViewCell.profileImageView.loadImage(from: imageURL)

            
            //cell.backgroundColor = UIColor.red
            return cell
        }
    }
    
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width/3 - 1)
        }
        
        return CGSize(width: collectionView.frame.size.width/3 - 1, height: collectionView.frame.size.width/3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

