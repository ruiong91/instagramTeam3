//
//  ViewController.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 10/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NewsFeedViewController: UIViewController, CommentPageDelegate {
    
    
    var dbRef : FIRDatabaseReference!
    
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var datatask : URLSessionDataTask?
    lazy var dateFormater : DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
        return _dateFormatter
    }()
    
    var posts : [Post] = []
    var currentPost : Post?
    var currentPostID : String?
    var likedBy : [String] = []
    var likedByString : String = "Liked by "
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dbRef = FIRDatabase.database().reference()
        observePosts()
        
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        
        
        
        //register custom cell
        newsFeedTableView.register(PostTableCell.cellNib,forCellReuseIdentifier: PostTableCell.cellIdentifier)
        
        //configure autolayout for height
        newsFeedTableView.estimatedRowHeight = 80
        newsFeedTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    
    func observePosts(){
        
        dbRef?.child("newsFeed").observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {return}
            let newPost = Post(withDictionary: value)
            newPost.postId = snapshot.key
            self.posts.append(newPost)
            self.newsFeedTableView.reloadData()
            
            
            dump(self.posts)
        })
    }
    
    //MARK: Likes/Comment func
    func presentCommentPage(indexPath: IndexPath?){
        guard let validIndexPath = indexPath else { return }
        let post = posts[validIndexPath.row]
        
        let commentPage = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController
        navigationController?.pushViewController(commentPage!, animated: true)
        
        commentPage?.currentPostID = post.postId
    }
    
    func saveLikes(btn : UIButton){
        let unlikedImage = UIImage(named: "like")
        let likedImage = UIImage(named: "liked")
        
        var likedUserDictionary : [String: String] = ["likedUserName" : User.current.username!, "likedUserID" : User.current.userID!]
        
        if btn.image(for: .normal) != likedImage {
            btn.setImage(likedImage, for: .normal)
            dbRef?.child("newsFeed").child(currentPostID!).child("likedBy").child(User.current.userID!).setValue(User.current.username)
        } else {
            btn.setImage(unlikedImage, for: .normal)
            dbRef?.child("newsFeed").child(currentPostID!).child("likedBy").child(User.current.userID!).removeValue()
        }
        newsFeedTableView.reloadData()
    }
    
    //    func reloadCell(indexPath : IndexPath){
    //        newsFeedTableView.reloadRows(at: [indexPath], with: .automatic)
    //    }
    //
    //    func observeLikes(){
    //        dbRef.child("newsFeed").child(currentPostID!).child("likedBy").observe(.childAdded, with: { (snapshot) in
    //
    //            //does not append??
    //            if let name = snapshot.value as? String {
    //                self.likedBy.append(name)
    //                print(self.likedBy)
    //            }
    //        })
    //    }
    
    //    func compileLikedUsers (label: UILabel){
    //        if likedBy.count == 0 {
    //            likedByString = "0 likes"
    //            print(likedByString)
    //        } else {
    //            for string in likedBy {
    //                if likedBy.count < 5 {
    //                    likedByString.append(string)
    //                    likedByString.append(", ")
    //                } else {
    //                    likedByString = "\(likedBy.count) likes"
    //                }
    //            }
    //        }
    //
    //        label.text = likedByString
    //    }
    
    
    //MARK: Outlets
    @IBOutlet weak var newsFeedTableView: UITableView!
    
}

//MARK: Extension
extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.cellIdentifier, for: indexPath) as? PostTableCell else {return UITableViewCell()}
        
        cell.delegate = self
        cell.indexPath = indexPath
        let post = posts[indexPath.row]
        currentPost = post
        
        if let timestamp = post.dateTime {
            cell.timestampLabel.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: timestamp))
        } else {
            cell.timestampLabel.text = ""
        }
        
        if post.image == nil {
            if let url = post.imageURL {
                datatask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
                    guard let validData = data else {return}
                    guard let image = UIImage(data: validData) else { return }
                    
                    post.image = image
                    DispatchQueue.main.async {
                        self.newsFeedTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                })
                datatask?.resume()
            }
        } else {
            cell.postImage.image = post.image
        }
        
        
        
        let name = post.senderName
        let bold = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
        let boldName = NSMutableAttributedString(string: name!, attributes: bold)
        let normalCaption = NSMutableAttributedString(string: "  \(post.caption ?? "")")
        boldName.append(normalCaption)
        
        cell.senderName.text = post.senderName
        cell.captionLabel.attributedText = boldName
        currentPostID = post.postId
        
        cell.noOfLikesLabel.text = post.numberOfLikes()
        
        return cell
    }
    
    
}



//why lazy var?
//how to call senderName via uid
//how come cell not streched out to view?
