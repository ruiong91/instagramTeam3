//
//  DetailsViewController.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 10/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseDatabase


class CommentsViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    var comments : [Comment] = []
    var currentPostID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        commentTableView.register(CommentTableCell.cellNib, forCellReuseIdentifier: "CommentTableCell")
        observeComments()
    }
    
    func observeComments(){
        dbRef.child("newsFeed").child(currentPostID!).child("comments").observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {return}
            let newComment = Comment(withDictionary: value)
            self.comments.append(newComment)
            self.commentTableView.reloadData()
        })
    }
    
    func postComment(){
        
        var commentDictionary : [String: Any] = ["commentor" : User.current.username, "content" : commentTF.text]
        
       dbRef.child("newsFeed").child(currentPostID!).child("comments").childByAutoId().setValue(commentDictionary)
    }
    
    
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var commentTF: UITextField!
    
    @IBOutlet weak var postBtn: UIButton!{
        didSet{
            postBtn.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        }
    }
    
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableCell", for: indexPath) as? CommentTableCell else {return UITableViewCell()}
        
        let comment = comments[indexPath.row]
        
        let name = comment.commentor
        let bold = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
        let boldName = NSMutableAttributedString(string: name!, attributes: bold)
        let normalContent = NSMutableAttributedString(string: "  \(comment.content ?? "")")
        boldName.append(normalContent)
        
        cell.commentLabel.attributedText = boldName
        
        
        return cell
    }
    
}
