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
    var photoURL: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var username : String?
    
    init() {}
    
    init(aCaption : String, aPhotoURL : String, anUid : String, anId : String, aLikeCount : Int, aLikes : Dictionary<String, Any>?, anIsLiked : Bool, anUsername : String){
        
        caption = aCaption
        photoURL = aPhotoURL
        uid = anUid
        id = anId
        likeCount = aLikeCount
        likes = aLikes
        isLiked = anIsLiked
        username = anUsername
        
    }
}

extension Post {
    
    static func transformPost(postDictionary: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.id = key
        post.caption = postDictionary["caption"] as? String
        post.photoURL = postDictionary["photoURL"] as? String
        post.uid = postDictionary["uid"] as? String
        post.likeCount = postDictionary["likesCount"] as? Int
        post.likes = postDictionary["likes"] as? Dictionary<String, Any>
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserID] != nil
            }
        }
        
        return post
    }
    
}
