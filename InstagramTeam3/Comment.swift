//
//  Comment.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 14/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation
import UIKit

class Comment {
    
    var commentor : String?
    var content : String?
    
    init(withDictionary dictionary: [String: Any]){
        commentor = dictionary["commentor"] as? String
        content = dictionary["content"] as? String
    }
}
