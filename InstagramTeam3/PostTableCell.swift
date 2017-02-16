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
}

class PostTableCell: UITableViewCell {
    
    weak var delegate : CommentPageDelegate?
    var indexPath : IndexPath?
    
    static let cellIdentifier = "PostTableCell"
    static let cellNib = UINib(nibName: "PostTableCell", bundle: Bundle.main)

    override func awakeFromNib() {
        super.awakeFromNib()
            }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

           }
    
    func handleComment(){
        delegate?.presentCommentPage(indexPath: indexPath)
    }
    
    func like(){
        
    }
    
    @IBOutlet weak var commentBtn: UIButton!{
        didSet{
            commentBtn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var likeBtn: UIButton!{
        didSet{
            like()
        }
    }
    
    
    @IBOutlet weak var senderProfileImage: UIImageView!
    @IBOutlet weak var senderName: UILabel!

    
    @IBOutlet weak var noOfLikesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var editPostBtn: UIButton!
    
}
