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
    var profilePicURL : String = ""
    
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionVIew.dataSource = self
        collectionVIew.delegate = self
        
        ref = Database.database().reference()
        
        guard let uid = Auth.auth().currentUser?.uid else {return}

        ref.child("Users").child(uid).observe(.value, with: { (snapshot) in
            
            print(snapshot.value)
            
            
        })
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10 //posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let headerViewCell = collectionVIew.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
            
            headerViewCell.labelUser.text = selectedContact?.fullname
            
            if let imageurl = selectedContact?.imageURL {
            
            headerViewCell.profileImageView.sd_setImage(with: URL(string: imageurl))
            }
            
            return headerViewCell

        }else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCollectionCell", for: indexPath) as! PictureCollectionViewCell
//            cell.post = posts[indexPath.row]
            cell.backgroundColor = UIColor.red
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
//        
//        headerViewCell.labelUser.text = selectedContact?.fullname
//        
//        return headerViewCell
//    }
    
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

