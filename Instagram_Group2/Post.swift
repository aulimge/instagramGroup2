//
//  Post.swift
//  Instagram_Group2
//
//  Created by Audrey Lim on 12/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}

