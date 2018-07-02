//
//  LoginInfo.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 25/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation


typealias Codable = Encodable & Decodable

var _currentUser: User_Info?

class User_Info: NSObject { //: Codable
    
    var user_Name: String
    var user_ID: String
    var user_Profile: String
    var screen_name: String
    
    init(user_Name: String, user_ID: String, user_Profile: String,screen_name: String ) {
        self.user_Name = user_Name
        self.user_ID = user_ID
        self.user_Profile = user_Profile
        self.screen_name = screen_name
    }
    
    //    enum CodingKeys: String, CodingKey {
    //        case user_Name = "user_Name"
    //        case user_ID = "user_ID"
    //        case user_Profile = "user_Profile"
    //    }
    
    
    
}

class Status: NSObject {
    
    var user: User_Info
    var text: String
    var createdAt: NSDate
    var numberOfRetweets: Int
    var numberOfFavorites: Int
    
    init(dictionary: NSDictionary) {
        self.user = User_Info.init(user_Name: "getScreenName", user_ID: "userID", user_Profile: "getprofileURL", screen_name: "getScreenName") // User_Info(dictionary: dictionary["user"] as NSDictionary)
        self.text = dictionary["text"] as! String
        
        var formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.date(from: dictionary["created_at"] as! String)! as NSDate
        
        self.numberOfRetweets = dictionary["retweet_count"] as! Int
        self.numberOfFavorites = dictionary["favorite_count"] as! Int
    }
    
    class func statusesWithArray(array: [NSDictionary]) -> [Status] {
        var statuses = [Status]()
        for dictionary in array {
            statuses.append(Status(dictionary: dictionary))
        }
        return statuses
    }
}
