//
//  User.swift
//  Instagram_Group2
//
//  Created by Audrey Lim on 12/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}

