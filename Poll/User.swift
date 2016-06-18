//
//  User.swift
//  Poll
//
//  Created by Brian Lee on 5/25/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    let dictionary: NSDictionary?
    let name: String?
    let email: String?
    let id: String?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        id = dictionary["id"] as? String
    }
    
    func logout(){
        User.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get{
            if _currentUser == nil{
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey(currentUserKey) as? NSData
                
                if userData != nil{
                    do{
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(userData!, options: NSJSONReadingOptions(rawValue:0)) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch{
                        print("error reading json")
                    }
                }
            }
            return _currentUser
        }
        set(user){
            
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if _currentUser != nil{
                do{
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: NSJSONWritingOptions(rawValue:0))
                    defaults.setObject(data, forKey: currentUserKey)
                } catch{
                    print("error writing json")
                }
            } else {
                defaults.setObject(nil, forKey: currentUserKey)
            }
            
            defaults.synchronize()
        }
    }
}
