//
//  NewsFeedTableCell.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 12/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit

class PostTableCell: UITableViewCell {
    
    static let cellIdentifier = "PostTableCell"
    static let cellNib = UINib(nibName: "PostTableCell", bundle: Bundle.main)

    override func awakeFromNib() {
        super.awakeFromNib()
            }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

           }
    
    
    
    
    @IBOutlet weak var senderProfileImage: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var noOfLikesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var editPostBtn: UIButton!
    
}
