//
//  PostViewController.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 13/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference?
    var selectedImage : UIImage?
    var selectedImageURL : URL?
    var currentposts : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        
        captionTextView.text = "Insert caption here..."
        textViewDidBeginEditing(captionTextView)
    }
    
    //MARK: functions
    func post () {
        let postIndex = currentposts.count
        var postDictionary : [String: Any] = ["senderID" : "setID", "senderName" : "setName", "image": selectedImageURL]
        
        if let caption = captionTextView.text{
            postDictionary["caption"] = caption
        } else {
            postDictionary["caption"] = ""
        }
        
        if selectedImage != nil {
            uploadImage(image: selectedImage!)
        }
        
        dbRef?.child("newsFeed").child(String(postIndex)).setValue(postDictionary)
        
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
                self.selectedImageURL = downloadUrl
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
