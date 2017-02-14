//
//  SignUpViewController.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 10/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var usernameTFS: UITextField!
    
    @IBOutlet weak var passwordTFS: UITextField!
    
    @IBOutlet weak var emailTFS: UITextField!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    var dbRef : FIRDatabaseReference!
    var users : [User] = []
    var ppImageURL : URL?
    
    // let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    //  var dataTask: URLSessionDataTask?
        
    @IBOutlet weak var signupBtn: UIButton!{
        didSet{
            signupBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
        
    }
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true){
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profilePicture.image = image
            uploadImage(profilePicture: image)
        }
        else{
            print(" +** |error| **+ ")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signUp(){
        FIRAuth.auth()?.createUser(withEmail: emailTFS.text!, password: passwordTFS.text!, completion: { (user, error) in
            if error != nil
            {
                print(error as! NSError)
                return
            }
            
            FIRStorage.storage().reference()
            
            //print(FIRUser.uid)
            
            let stringPpUrl = String(describing: self.ppImageURL)
            
            let userDictionary : [String: Any] = ["email" : self.emailTFS.text ?? "","username" : self.usernameTFS.text ?? "", "password" : self.passwordTFS.text ?? "", "ppImageURL" : stringPpUrl]
            
            guard let validUserID = user?.uid else { return }
            
            self.dbRef.child("users").updateChildValues([validUserID:userDictionary])
        })
    }
    
    //  let userPhoto = ["imageUrl" : String(describing: user?.photoURL!)]
    
    func uploadImage(profilePicture: UIImage){
        let picstorage = FIRStorage.storage()
        let storageRef = picstorage.reference(forURL: "gs://instagramteam3-393b9.appspot.com")
        
        //let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        let convertedTimeStamp = timestamp.replacingOccurrences(of: ".", with: "")
        let imageName = ("image \(convertedTimeStamp).jpeg")
        
        //also have png representation
        guard let imageData = UIImageJPEGRepresentation(profilePicture, 0.8) else {return}
        storageRef.child(imageName).put(imageData, metadata: metadata) { (meta, error) in
            
            self.dismiss(animated: true, completion: nil)
            
            if error != nil {
                return
            }
            
            if let downloadUrl = meta?.downloadURL() {
                self.ppImageURL = downloadUrl
                
            } else {
                //error
            }
        }
    }
    
    
}





