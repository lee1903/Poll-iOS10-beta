//
//  ViewController.swift
//  Poll
//
//  Created by Brian Lee on 5/25/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in...")
        } else {
            print("User logged in...")
        }
        
        configureFacebookButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFacebookButton(){
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        fbLoginButton.delegate = self
    }
    
    func setUserData(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("error retreiving information")
            }
            else
            {
                let name = result.valueForKey("name") as! String
                let email = result.valueForKey("email") as! String
                let id = result.valueForKey("id") as! String
                
                let dictionary = ["name": name, "email": email, "id": id]
                User.currentUser = User(dictionary: dictionary)
            }
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if(error == nil) {
            print("Login complete...")
            setUserData()
            
            self.performSegueWithIdentifier("loginComplete", sender: self)
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        User.currentUser?.logout()
        print("User logged out...")
    }


}

