//
//  Post.swift
//  Instagram_Group2
//
//  Created by Audrey Lim on 12/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import Foundation

//struct Post {
//    var id : String = ""
//    var imageUrl: String
//    
//    
//    init(dictionary: [String: Any]) {
//        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
//    }
//}

import FirebaseAuth


class Post {
    var caption: String?
    var imageURL: String?
    var imageFilename: String?
    var id: String?
    var likeCount: Int?
    var likes: [String:Any]?
    var isLiked: Bool?
    var username : String?
    var comment : String?
    
    init() {}
    
    init(aCaption : String, aImageURL : String, aImageFilename : String, anId : String, aLikeCount : Int, aLikes : [String:Any]?, anIsLiked : Bool, anUsername : String, aComment : String) {
        
        caption = aCaption
        imageURL = aImageURL
        imageFilename = aImageFilename
        id = anId
        likeCount = aLikeCount

        if let like = aLikes {
            likes = like
        }
        
        isLiked = anIsLiked
        username = anUsername
        comment = aComment
        
    }
}

extension Post {
    
    static func transformPost(postDictionary: [String: Any], key: String) -> Post {
        var post = Post()
//        
//        post.id = key
        if let caption = postDictionary["caption"] as? String,
        let imageURL = postDictionary["imageURL"] as? String,
        let imageFilename = postDictionary["imageFilename"] as? String,
        let postID = postDictionary["uid"] as? String,
            let postLikeCount = postDictionary["likesCount"] as? Int,
        let postIsLiked = postDictionary["isLiked"] as? Bool,
        let username = postDictionary["username"] as? String,
        let comment = postDictionary["comment"] as? String{
            
            let tempPost = Post(aCaption: caption, aImageURL: imageURL, aImageFilename: imageFilename, anId: postID, aLikeCount: postLikeCount, aLikes: nil, anIsLiked: postIsLiked, anUsername: username, aComment: comment)
            
            if let likes = postDictionary["likes"] as? [String:Any] {
                post.likes = likes
            }
            
            post = tempPost
            
            
        }
  
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            if post.likes != nil {
//                post.isLiked = post.likes[currentUserID] != nil
//            }
//        }
        
        return post
    }
    
}
