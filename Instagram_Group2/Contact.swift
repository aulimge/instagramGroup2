//
//  Contact.swift
//  Instagram_Group2
//
//  Created by Audrey Lim on 13/09/2017.
//  Copyright © 2017 Audrey Lim. All rights reserved.
//

import Foundation


class Contact {
    var id : String = ""
    var username : String = ""
    var fullname : String = ""
    var email : String = ""
    var imageURL : String = ""
    var filename : String = ""
    var firstname : String = ""
    var lastname : String = ""
    
    static var currentUser : Contact?
    
    init(anID : String, aUsername : String, aFullname : String, anEmail : String, anImageURL : String, anFilename : String, aFirstname : String, aLastname : String  ) {
        id = anID
        username = aUsername
        fullname = aFullname
        email = anEmail
        imageURL = anImageURL
        filename = anFilename
        firstname = aFirstname
        lastname = aLastname
    }
    
}
