//
//  PostViewController.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 13/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference?
    
    var selectedImage : UIImage?
    var selectedImageStringURL : String?
    var currentposts : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        //currentUserID = FIRAuth.auth()?.currentUser?.uid
        captionTextView.text = "Insert caption here..."
        textViewDidBeginEditing(captionTextView)
        
    }
    
    //MARK: functions
    func post () {
        
        
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        var postDictionary : [String: Any] = ["senderID" : User.current.userID, "senderName" : User.current.username, "imageStringURL": selectedImageStringURL, "dateTime" : timestamp]
        
        if let caption = captionTextView.text{
            postDictionary["caption"] = caption
        } else {
            postDictionary["caption"] = ""
        }
        
//        dbRef?.child("newsFeed").child(String(postIndex)).setValue(postDictionary)
        dbRef?.child("newsFeed").childByAutoId().setValue(postDictionary)
        
        
//        dbRef?.observeSingleEvent(of: .childAdded, with: { (snapshot) in
//            snapshot.childrenCount
//        })
        
//        dbRef?.queryEqual(toValue: "newsFeed")
        
        print(postDictionary)
    }
    
    func clearTextView(textView : UITextView) {
        textView.text = ""
    }
    
    
    
    //MARK: Outlets
    @IBOutlet weak var openLibraryBtn: UIButton!{
        didSet{
            openLibraryBtn.addTarget(self, action: #selector(displayImagePicker), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var openCameraBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!{
        didSet{
            shareBtn.addTarget(self, action: #selector(post), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    
}

//MARK: extensions
extension PostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func displayImagePicker(){
        let pickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            pickerController.sourceType = .photoLibrary
            pickerController.delegate = self
            
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image =  info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImage = image
            imagePreview.image = selectedImage
            uploadImage(image: selectedImage!)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func uploadImage (image: UIImage){
        let storageRef = FIRStorage.storage().reference()
        var metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        let convertedTimeStamp = timestamp.replacingOccurrences(of: ".", with: "")
        let imageName = ("image \(convertedTimeStamp).jpeg")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        storageRef.child(imageName).put(imageData, metadata: metadata) { (meta, error) in
            
            if let downloadUrl = meta?.downloadURL() {
                self.selectedImageStringURL = String(describing: downloadUrl)
            } else {
                //error
            }
        }
    }
}

extension PostViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Insert caption here..." {
            textView.text = ""
        }
    }
    
}

//why cant i call upload image when post. wont i save too many spam image?
