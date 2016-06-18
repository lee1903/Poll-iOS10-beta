//
//  APIClient.swift
//  Poll
//
//  Created by Brian Lee on 5/26/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import Foundation
import AFNetworking

class APIClient {
    static let http = AFHTTPSessionManager()
    static let apiURL = "http://10.0.0.166:8080/"
    
    private class func getDateString(currentDate: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy / HH:mm:ss"
        let date = dateFormatter.stringFromDate(currentDate) 
        return date
    }
    
    private class func getPollsFromResponse(response: AnyObject) -> [Poll] {
        var polls: [Poll] = []
        
        print(response)
        
        let array = response as! NSArray
        for dictionary in array {
            let poll = Poll(dictionary: dictionary as! NSDictionary, author: User.currentUser!)
            polls.append(poll)
        }
        return polls
    }
    
    class func getPolls(completion: (polls: [Poll]?, error: NSError?) -> ()){
        
        let url = apiURL + "polls/"
        
        http.GET(url, parameters: [], progress: { (progress: NSProgress) -> Void in
            }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                print(response)
                completion(polls: nil, error: nil)
                
                
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            
            completion(polls: nil, error: error)
        }
    }

    
    class func createPoll(poll: Poll, completion: (response: [String]?, error: NSError?) -> ()){
        
        let url = apiURL + "polls/"
        let params = ["title" : "\(poll.title!)", "date": "\(getDateString(poll.date!))", "optionsCount" : "\(poll.optionsCount!)", "latitude" : "\(poll.location!.coordinate.latitude)", "longitude" : "\(poll.location!.coordinate.longitude)", "author": "\(poll.author!.id!)"]
        
        http.POST(url, parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                let dictionary = response! as! NSDictionary
                let id = "\(dictionary["id"]!)"
                let server_id = dictionary["server_id"] as! String
                
                let res = [id, server_id]
                
                completion(response: res, error: nil)
                
                
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            
            completion(response: nil, error: error)
        }
    }
    
    class func endPoll(poll: Poll, completion: (error: NSError?) -> ()){
        
        let url = apiURL + "polls/id=\(poll.id!)"
        let params = ["status": "expire"]
        
        http.PUT(url, parameters: params, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
                print(response!)
                completion(error: nil)
                
                
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in

            completion(error: error)
        }
    }
    
    class func answerPoll(pollid: String, response: String, completion: (error: NSError?) -> ()){
        
        let url = apiURL + "polls/id=\(pollid)"
        let params = ["response": response, "user": User.currentUser!.name!]
        
        http.PUT(url, parameters: params, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            print(response!)
            completion(error: nil)
            
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in

            completion(error: error)
        }
    }
    
    class func joinPoll(id: String, completion: (optionsCount: String?, longitude: String?, latitude: String?, error: NSError?) -> ()){
        
        let url = apiURL + "polls/id=\(id)"
        
        http.GET(url, parameters: [], progress: { (progress: NSProgress) in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) in

            let dictionary = response! as! NSDictionary
            let optionsCount = dictionary["optionsCount"] as! String
            let longitude = dictionary["longitude"] as! String
            let latitude = dictionary["latitude"] as! String
                
            completion(optionsCount: optionsCount, longitude: longitude, latitude: latitude, error: nil)
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) in
            
            completion(optionsCount: nil, longitude: nil, latitude: nil, error: error)
        }
    }
    
    class func getPollStats(id: String, completion: (stats: [[String]]?, error: NSError?) -> ()){
        
        let url = apiURL + "polls/id=\(id)"
        
        http.GET(url, parameters: [], progress: { (progress: NSProgress) in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionary = response! as! NSDictionary
            let stats = dictionary["stats"] as! [[String]]
            
            completion(stats: stats, error: nil)
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) in
            
            completion(stats: nil , error: error)
        }
    }
    
    class func getHistory(author: String, completion: (polls: [Poll]?, error: NSError?) -> ()){
        
        let url = apiURL + "polls/author=\(author)"
        
        http.GET(url, parameters: [], progress: { (progress: NSProgress) in }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) in
            
            let polls = getPollsFromResponse(response!)
            
            completion(polls: polls, error: nil)
            
        }) { (dataTask: NSURLSessionDataTask?, error: NSError) in
            
            completion(polls: nil , error: error)
        }
    }
    
    class func deletePoll(server_id: String, completion: (error: NSError?) -> ()){
        
        let url = apiURL + "polls/\(server_id)"
        
        http.DELETE(url, parameters: [], success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) in
            
            completion(error: nil)
            
            }) { (dataTask: NSURLSessionDataTask?, error: NSError) in
                
                completion(error: error)
        }
    }

}
