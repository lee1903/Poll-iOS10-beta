//
//  UserViewController.swift
//  Poll
//
//  Created by Brian Lee on 6/4/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        User.currentUser?.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
