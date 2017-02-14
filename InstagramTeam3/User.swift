//
//  User.swift
//  InstagramTeam3
//
//  Created by Othman Mashaab on 13/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class User {
    var id : String?
    var userID : String?
    var email : String?
    var password : String?
    var username : String?
    
    var dbRef : FIRDatabaseReference!
    
    static let currentUserID = FIRAuth.auth()?.currentUser?.uid
    
    init(withDictionary dictionary: [String : Any], index: Int) {
        id = String(index)
        userID = dictionary["userID"] as? String
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
    }
    
    
}
