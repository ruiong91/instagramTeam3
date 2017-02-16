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
    //var postId : String?
    var senderName : String?
    var senderID : String?
    var imageURL : URL?
    var image : UIImage?
    var caption : String?
    var likedBy : [String]?
    var comments : [Comment]?
    var dateTime : TimeInterval?
    var postId : String = ""
    
    init(withDictionary dictionary: [String: Any]){
        
        senderName = dictionary["senderName"] as? String
        senderID = dictionary["senderID"] as? String
        image = dictionary["image"] as? UIImage
        caption = dictionary["caption"] as? String
        likedBy = dictionary["likedBy"] as? [String]
        comments = dictionary["comments"] as? [Comment]
        
        if let imageStringURL = dictionary["imageStringURL"] as? String {
            imageURL = URL(string: imageStringURL)
        }
        
        if let timeIntervalString = dictionary["dateTime"] as? String {
            dateTime = TimeInterval(timeIntervalString)
        }
        
        if let allComments = dictionary["comments"] as? [Any] {
            for aComment in allComments {
                if let commentValue = aComment as? [String: Any]{
                    let newComment = Comment(withDictionary: commentValue)
                    comments?.append(newComment)
                }
            }
        }
    }
}
