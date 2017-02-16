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
    
    
    var dbRef : FIRDatabaseReference?
    
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var datatask : URLSessionDataTask?
    lazy var dateFormater : DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
        return _dateFormatter
    }()
    
    var posts : [Post] = []
    
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
    
    func presentCommentPage(indexPath: IndexPath?){
        guard let validIndexPath = indexPath else { return }
        let post = posts[validIndexPath.row]
        
        let commentPage = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController
        navigationController?.pushViewController(commentPage!, animated: true)
        
        commentPage?.currentPostID = post.postId
    }
    
    func identifyCurrentPost(){
        
    }
    
//    func getSenderName() {
//            dbRef?.child("users").child(!).observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let username = value?["userName"] as? String ?? ""
//            NewsFeedViewController.currentUserName = username
//        })
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
        
        
        return cell
    }
}

//why lazy var?
//how to call senderName via uid
//how come cell not streched out to view?
