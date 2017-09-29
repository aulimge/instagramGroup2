//
//  Comment.swift
//  Instagram_Group2
//
//  Created by Tan Wei Liang on 25/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import Foundation
class Comment {
    var commentText: String?
    var uid: String?
    var username : String?
   
    
    init(text: String, aUid: String, name: String) {
        commentText = text
        uid = aUid
        username = name
    }
    
    init() {
        
    }
    
}

extension Comment {
    
    static func transformComment(postDictionary: [String: Any]) -> Comment  {
        let comment = Comment()
        
        comment.commentText = postDictionary["text"] as? String
        comment.uid = postDictionary["userID"] as? String
        comment.username = postDictionary["name"] as? String
        
        return comment
    }
    
}
