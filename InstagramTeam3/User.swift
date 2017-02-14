//
//  User.swift
//  InstagramTeam3
//
//  Created by Othman Mashaab on 13/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var profilepicture : String?
    var id : String?
    var userID : String?
    var email : String?
    var password : String?
    
    init(withDictionary dictionary: [String : Any], index: Int) {
        id = String(index)
        userID = dictionary["userID"] as? String
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
        profilepicture = dictionary["profilepicture"] as? String
        
    }
}
