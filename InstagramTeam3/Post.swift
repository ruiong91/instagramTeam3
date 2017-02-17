//
//  Post.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 13/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Post {
    
    var senderName : String?
    var senderID : String?
    var imageURL : URL?
    var image : UIImage?
    var caption : String?
    var likedBy : [String : String]?
    var comments : [Comment]?
    var dateTime : TimeInterval?
    var postId : String = "" {
        didSet {
            observeLikes(postID: postId)
        }
    }
    var dbRef : FIRDatabaseReference!

    init(withDictionary dictionary: [String: Any]){
        
        senderName = dictionary["senderName"] as? String
        senderID = dictionary["senderID"] as? String
        image = dictionary["image"] as? UIImage
        caption = dictionary["caption"] as? String
        likedBy = dictionary["likedBy"] as? [String : String]
        comments = dictionary["comments"] as? [Comment]
        
        dbRef = FIRDatabase.database().reference().child("newsFeed")
        
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
    
    var userWhoLikes : [String] = []
    
    func observeLikes(postID: String){
        dbRef.child(postID).child("likedBy").observe(.childAdded, with: { (snapshot) in
            
            //use query better
            if let name = snapshot.value as? String {
                
                self.userWhoLikes.append(name)
            }
        })
    }
    
    func numberOfLikes() -> String {
        return "\(userWhoLikes.count) Likes"
    }

}
