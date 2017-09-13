//
//  HomeTableViewCell.swift
//  Instagram_Group2
//
//  Created by Tan Wei Liang on 12/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
     @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    var postReference: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
//    func handleLikeTap() {
//        postReference = API.Post.REF_POSTS.child(post!.id!)
//        incrementLikes(forReference: postReference)
//    }
//    
//    func incrementLikes(forReference ref: DatabaseReference) {
//        // Dealing with concurrent modifications based on:
//        // https://firebase.google.com/docs/database/ios/read-and-write
//        // Section: Save data as transactions
//        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
//            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
//                var likes: Dictionary<String, Bool>
//                likes = post["likes"] as? [String : Bool] ?? [:]
//                var likeCount = post["likeCount"] as? Int ?? 0
//                if let _ = likes[uid] {
//                    // Unlike the post and remove self from stars
//                    likeCount -= 1
//                    likes.removeValue(forKey: uid)
//                } else {
//                    // Like the post and add self to stars
//                    likeCount += 1
//                    likes[uid] = true
//                }
//                post["likeCount"] = likeCount as AnyObject?
//                post["likes"] = likes as AnyObject?
//                
//                // Set value and report transaction success
//                currentData.value = post
//                
//                return TransactionResult.success(withValue: currentData)
//            }
//            return TransactionResult.success(withValue: currentData)
//        }) { (error, committed, snapshot) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            
//            if let postDictionary = snapshot?.value as? [String:Any] {
//                let post = Post.transformPost(postDictionary: postDictionary, key: snapshot!.key)
//                self.updateLike(post: post)
//            }
//        }
//    }
//    
//    func updateLike(post: Post) {
//        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
//        likeImageView.image = UIImage(named: imageName)
//        
//        // display a message for Likes
//        guard let count = post.likeCount else {
//            return
//        }
//        
//        if count != 0 {
//            likeCountButton.setTitle("\(count) Likes", for: .normal)
//        } else if post.likeCount == 0 {
//            likeCountButton.setTitle("Be the first to Like this", for: .normal)
//        }
//    }

    
   }
