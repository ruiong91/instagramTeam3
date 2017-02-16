//
//  CommentTableCell.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 12/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit

class CommentTableCell: UITableViewCell {

    
    static let cellIdentifier = "CommentTableCell"
    static let cellNib = UINib(nibName: "CommentTableCell", bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var commentLabel: UILabel!
}
