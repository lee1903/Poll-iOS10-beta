//
//  NavViewController.swift
//  Poll
//
//  Created by Brian Lee on 5/25/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class NavViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var takeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.08, green:0.41, blue:0.59, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        tabBarController?.tabBar.barTintColor = UIColor(red:0.08, green:0.41, blue:0.59, alpha:1.0)
        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        createButton.layer.cornerRadius = 8        
        takeButton.layer.cornerRadius = 8
        
        print(User.currentUser!.name!)
        print(User.currentUser!.email!)
        print(User.currentUser!.id!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func onLogout(sender: AnyObject) {
//        let loginManager = FBSDKLoginManager()
//        loginManager.logOut() // this is an instance function
//        User.currentUser?.logout()
//    }

    
    @IBAction func onCreatePoll(sender: AnyObject) {
        self.performSegueWithIdentifier("SetPollOptions", sender: self)
    }
    
    @IBAction func onTakePoll(sender: AnyObject) {
        self.performSegueWithIdentifier("TakePoll", sender: self)
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
