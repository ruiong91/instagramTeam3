//
//  ViewController.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 10/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewsFeedViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference?
    var posts : [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
       
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        
        //register custom cell
        newsFeedTableView.register(PostTableCell.cellNib,forCellReuseIdentifier: PostTableCell.cellIdentifier)
        
        //configure autolayout for height
        newsFeedTableView.estimatedRowHeight = 80
        newsFeedTableView.rowHeight = UITableViewAutomaticDimension
        
    }

//    func observePosts(){
//        dbRef?.child("newsFeed").observe(.childAdded, with: { (snapshot) in
//            guard let value = snapshot.value as? [String: Any] else {return}
//            let newPost = Post(withDictionary: value, index: index)
//        })
//    }
    
    
    @IBOutlet weak var newsFeedTableView: UITableView!

}

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.cellIdentifier, for: indexPath) as? PostTableCell else {return UITableViewCell()}
        
        let post = posts[indexPath.row]
        
        return cell
    }
}
