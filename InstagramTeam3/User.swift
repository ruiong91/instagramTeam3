//
//  User.swift
//  InstagramTeam3
//
//  Created by Othman Mashaab on 13/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class User {
    
    var userID : String?
    var username : String?
    var email : String?
    var password : String?
    var profilepicture : String?
    
    
    
    static var current : User = User()
    init(){}
    
    init(withDictionary dictionary: [String : Any]) {
        userID = dictionary["userID"] as? String
        username = dictionary["username"] as? String
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
        profilepicture = dictionary["ppImageURL"] as? String
    }
    
    
    func fetchUserInformationViaID() {
        FIRDatabase.database().reference().child("users").child(userID!).observe(.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {return}
            let newUser = User(withDictionary: value)
            newUser.userID = snapshot.key
            
            User.current = newUser

        })
    }
}
