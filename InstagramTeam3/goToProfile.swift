//
//  goToProfile.swift
//  InstagramTeam3
//
//  Created by Othman Mashaab on 17/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class goToProfileViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var pictureContainer: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var Users: NSDictionary?
    var dbRef : FIRDatabaseReference!
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var datatask : URLSessionDataTask?
    var currentUserID : String?
    var selectedImage : UIImage?
    var selectedImageStringURL : String?
    var currentposts : [Post] = []
    var currentUser = ""
    
    
    //dbRef?.child("users").child(User.currentUserID!)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        //        avatarImage.image = UIImage(named: Users?["profilepicture"] as! String!)
        //   collectionView.dataSource = self
        //   collectionView.backgroundColor = UIColor.white
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: {(snapshot) in
                let dictionary = snapshot.value as? NSDictionary
                
               let username = dictionary?["username"] as? String?; "username"
                
                NewsFeedViewController.currentUserName = "username"
                
                if let profilePicURL = dictionary?["ppImageURL"]as? String{
                    let url = URL(string: profilePicURL)
                    URLSession.shared.dataTask(with: url!, completionHandler:{ (data, response, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            
                            self.title = "Welcome\((self.Users!["username"]!))!"
                            self.pictureContainer.image = UIImage(data: data!)
                        }
                    }).resume()
                }
                
                self.usernameLabel.text=username!
                
                //self.postsLabel.text = "\(username.posts.count)"
                //                self.followerLabel.text = "\(profileUser.followers.count)"
                //                self.followLabel.text = "\(profileUser.following.count)"
                
            }) {(error) in
                print(error.localizedDescription)
                return
                
            }
            
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 0
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    func getUsername() {
        dbRef.child("users").child(User.currentUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["userName"] as? String ?? ""
            NewsFeedViewController.currentUserName = username
        })
    }
    
    
    
}
