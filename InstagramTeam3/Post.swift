//
//  Post.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 13/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var postId : String?
    var senderName : String?
    var senderID : String?
    var image : UIImage?
    var caption : String?
    var likedBy : [String]?
    
    init(withDictionary dictionary: [String: Any], index: Int){
        postId = String(index)
        senderName = dictionary["senderName"] as? String
        senderID = dictionary["senderId"] as? String
        image = dictionary["image"] as? UIImage
        caption = dictionary["caption"] as? String
        likedBy = dictionary["likedBy"] as? [String]
    }
}
