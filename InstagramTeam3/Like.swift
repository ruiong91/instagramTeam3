//
//  Like.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 16/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation

class Like {
    
    var likedUserName : String?
    var likedUserID : String?
    
    init(withDictionary dictionary: [String: Any]){
        likedUserName = dictionary["likedUserName"] as? String
        likedUserID = dictionary["likedUserID"] as? String
    }

}
