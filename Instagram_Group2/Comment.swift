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
}

extension Comment {
    
    static func transformComment(postDictionary: [String: Any]) -> Comment  {
        let comment = Comment()
        
        comment.commentText = postDictionary["commentText"] as? String
        comment.uid = postDictionary["uid"] as? String
        
        return comment
    }
    
}
