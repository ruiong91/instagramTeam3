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


class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTFS: UITextField!

    @IBOutlet weak var passwordTFS: UITextField!
    
    @IBOutlet weak var emailTFS: UITextField!
    
    
    var dbRef : FIRDatabaseReference!
    var users : [User] = []
    
    @IBOutlet weak var signupBtn: UIButton!{
        didSet{
            signupBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dbRef = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUp(){
        FIRAuth.auth()?.createUser(withEmail: emailTFS.text!, password: passwordTFS.text!, completion: { (user, error) in
            if error != nil {
                print(error as! NSError)
                return
            }
            
           // print(FIRUser.uid)
            
            let userDictionary : [String: Any] = ["email" : self.emailTFS.text ?? "","username" : self.usernameTFS.text ?? "", "password" : self.passwordTFS.text ?? ""]
            
            guard let validUserID = user?.uid else { return }
            
            self.dbRef.child("users").updateChildValues([validUserID:userDictionary])
            
        })
        
    }

    

}
