//
//  ViewController.swift
//  Instagram_Group2
//
//  Created by Audrey Lim on 11/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {
    
    var posts : [Post] = []
    var ref: DatabaseReference!
    
    //Define private var for this module
    var g_userId : String = ""
    var g_userName : String = ""
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        signOutUser()
        
    }
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetchPost() {
        ref = Database.database().reference()
        
        //observe child added works as a loop return each child individually
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any]
                else { return }
            print("info: \(info)")
            print(snapshot)
            print(snapshot.key)
            
            //cast snapshot.value to correct Datatype
            
            if let caption = info["caption"] as? String,
                let imageURL = info["imageURL"] as? String,
                let imageFilename = info["imageFilename"] as? String,
                let id = info["id"] as? String,
                let likeCount = info["likeCount"] as? Int,
                let likes = info["likes"] as? String,
            let isLiked = info["isLiked"] as? Bool,
            let username = info["username"] as? String {
                
                
                
                
                //create new contact object
                let newPost = Post(aCaption: caption, aImageURL: imageURL, aImageFilename: imageFilename, anId: id, aLikeCount: likeCount, aLikes: nil, anIsLiked: isLiked, anUsername: username)
                print(newPost)
                
                //append to contact array
                self.posts.append(newPost)
                
                
                //this is more efficient
                //insert indv rows as we retrive idv items
                let  index = self.posts.count - 1
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .right)
            }
            
        })
        
        ref.child("Posts").observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any]
                else { return }
            
            print (info)
        })
        
        ref.child("Posts").observe(.childRemoved, with: { (snapshot) in
            guard let info = snapshot.value as? [String : Any ] else { return }
            print(info)
            
            let deletedID = snapshot.key
            
            
            //filters through post returns index(deletedIndex) where Boolean condition is fulfilled
            if let deletedIndex = self.posts.index(where: { (student) -> Bool in
                return student.id == deletedID
            }) {
                //remove post when deletedIndex is found
                self.posts.remove(at: deletedIndex)
                let indexPath = IndexPath(row: deletedIndex, section: 0)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        })
        
        ref.child("Posts").observe(.childChanged, with: { (snapshot) in
            guard let info = snapshot.value as? [String:Any] else {return}
            
            guard let caption = info["caption"] as? String,
                let imageURL = info["imageURL"] as? String,
                let imageFilename = info["imageFilename"] as? String,
                let id = info["id"] as? String,
                let likeCount = info["likeCount"] as? Int,
                let isLiked = info["isLiked"] as? Bool,
                let username = info["username"] as? String else {return}
            
            if let matchedIndex = self.posts.index(where: { (post) -> Bool in
                return post.id == snapshot.key
            }) {
                let changedPost = self.posts[matchedIndex]
                changedPost.caption = caption
                changedPost.imageURL = imageURL
                changedPost.imageFilename = imageFilename
                changedPost.id = id
                changedPost.likeCount = likeCount
                if let likes = info["likes"] as? [String:Any] {
                    changedPost.likes = likes
                }
                changedPost.isLiked = isLiked
                changedPost.username = username
                
                let indexPath = IndexPath(row: matchedIndex, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        fetchPost()
      
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            commentVC.postID = sender as! String
        }
    }
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as?
            HomeTableViewCell
            else { return UITableViewCell() }
        
            
        
        //Read all the post here
        cell.nameLabel.text = posts[indexPath.row].username
        if let imageURL = posts[indexPath.row].imageURL
        {
            cell.postImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "Instagram icon"), options: .progressiveDownload, completed: nil)
        }else {
            cell.postImageView.image = #imageLiteral(resourceName: "Instagram icon")
        }
        
        
        
        
       // let imageURL2 = posts[indexPath.row].
        // cell.postImageView.loadImage(from: imageURL!)
        
       
        cell.captionLabel.text = posts[indexPath.row].caption
        
        
        if posts[indexPath.row].isLiked! == true {
            cell.likeImageView.image = (#imageLiteral(resourceName: "likeIcon_filled"))

        } else {
            cell.likeImageView.image = (#imageLiteral(resourceName: "icons8-like"))
        }
            
        
        if posts[indexPath.row].likeCount! == 0 {
            cell.likeCountButton.titleLabel?.text = "Be the First to like"
            
        } else {
             cell.likeCountButton.titleLabel?.text = "\(posts[indexPath.row].likeCount!) Likes"
        }

        cell.nameLabel.text = posts[indexPath.row].username
        
        
        
        return cell
        
    }
}
