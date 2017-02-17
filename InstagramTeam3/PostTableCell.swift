//
//  NewsFeedTableCell.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 12/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol CommentPageDelegate : class {
    func presentCommentPage(indexPath: IndexPath?)
//    func observeLikes()
    func saveLikes(btn : UIButton)
//    func compileLikedUsers (label: UILabel)
//    func reloadCell(indexPath : IndexPath)
}

class PostTableCell: UITableViewCell {
    
    var dbRef : FIRDatabaseReference!
    weak var delegate : CommentPageDelegate?
    var indexPath : IndexPath?
    var currentPostID : String?
    
    
    static let cellIdentifier = "PostTableCell"
    static let cellNib = UINib(nibName: "PostTableCell", bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dbRef = FIRDatabase.database().reference()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func handleComment(){
        delegate?.presentCommentPage(indexPath: indexPath)
    }
    
    
    func handleLike(){
        delegate?.saveLikes(btn: likeBtn)
//        delegate?.observeLikes()
//        delegate?.compileLikedUsers(label: noOfLikesLabel)
    }
//        // use this isntead
//        dbRef.child("newsFeed").child(currentPostID!).child("likedBy").child(User.current.userID!).setValue("name")
//        
//        // remove 1
//        dbRef.child("newsFeed").child(currentPostID!).child("likedBy").child(User.current.userID!).setValue("")
//        
//        // remove 2
//        dbRef.child("newsFeed").child(currentPostID!).child("likedBy").child(User.current.userID!).removeValue()
//        
//     
//        
//        // obseru user
//        
//        var userLikesName : [String] = []
//        for likedUserID in likedBy! {
//            dbRef.child("users").child(likedUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//                userLikesName.append(snapshot.value["username"] as! String)
//            })
//        }
//    }
//    
    
    @IBOutlet weak var commentBtn: UIButton!{
        didSet{
            let commentImage = UIImage(named: "comment")
            commentBtn.setImage(commentImage, for: .normal)
            commentBtn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var likeBtn: UIButton!{
        didSet{
            let unlikedImage = UIImage(named: "like")
            likeBtn.setImage(unlikedImage, for: .normal)
            
            likeBtn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var senderProfileImage: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    
    
    @IBOutlet weak var noOfLikesLabel: UILabel!{
        didSet{
            noOfLikesLabel.text = ""
        }
    }
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var editPostBtn: UIButton!
    
}
