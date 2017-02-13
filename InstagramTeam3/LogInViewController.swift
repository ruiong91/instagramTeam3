//
//  LogInViewController.swift
//  InstagramTeam3
//
//  Created by Rui Ong on 10/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

var currentUser : String?
class LogInViewController: UIViewController {

    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signupBtn: UIButton!{
        didSet{
            signupBtn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func login(){
        
        FIRAuth.auth()?.signIn(withEmail: usernameTF.text!, password: passwordTF.text!, completion: { (user, error) in
            
            //check if error
            if error != nil {
                print(error as! NSError)
                return
            }
            
            //get the user
            self.handleUser(user: user!)
            
        })
        
    }
    
    func signup(){
        
    }
    
    func handleUser(user: FIRUser){
        print("user logged in")
        loadNewsfeedPage()
        }
    
    func loadSignUp(){
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let signUpPage = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        navigationController?.pushViewController(signUpPage!, animated: true)
    }
    
    func loadNewsfeedPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let channelPage = storyboard.instantiateViewController(withIdentifier: "NewsFeedViewController") as? NewsFeedViewController
        
        navigationController?.pushViewController(channelPage!, animated: true)
    }
    

}
