//
//  User.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation



internal class User: NSObject {
    
    // MARK: Stored Properties
    private(set) var name: String?
    private(set) var createdAt: Date?
    private(set) var tagline: String?
    private(set) var screenName: String?
    private(set) var followersCount: Int = 0
    private(set) var profileURL: URL?
    private(set) var profileBannerImageURL: URL?
    private(set) var tweetsCount: Int = 0
    private(set) var followingCount: Int = 0
    private(set) var isVerified: Bool?
    private(set) var dictionary: [String: Any]?
    
    internal static var currentUser: User?
    
    // MARK: Computed Properties
    internal static var isUserLoggedIn: Bool = {
        return _currentUser != nil
    }()
    
    private class var _currentUser: User? {
        get {
            if currentUser == nil {
                if let data = UserDefaults.standard.object(forKey: "currentUser") as? NSData, let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [String: Any] {
                    let user = User(dictionary: dictionary )
                    currentUser = user
                }
            }
            return currentUser
        }
        
        set(newUser) {
            currentUser = newUser
            if let user = newUser, let dict = user.dictionary {
                let data = NSKeyedArchiver.archivedData(withRootObject: dict)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey:"currentUser")
             }
        }
    }
    
    // MARK: Initializers
    init(dictionary: [String: Any]) {
        
        self.dictionary = dictionary
        
        if let timeStampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: timeStampString)
        }
        
        tagline = dictionary["description"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        if let verified = dictionary["verified"] as? NSNumber {
            isVerified = verified != 0
        }
        
        self.followersCount = (dictionary["followers_count"] as? Int) ?? 0
        
        if let profileURLString = dictionary["profile_image_url_https"] as? String {
            profileURL = URL(string: profileURLString)
        }
        
        if let profileBannerImageURLString = dictionary["profile_banner_url"] as? String {
            profileBannerImageURL = URL(string: profileBannerImageURLString)
        }
        
        self.tweetsCount = (dictionary["statuses_count"] as? Int) ?? 0
        
        self.followingCount = (dictionary["friends_count"] as? Int) ?? 0
    }
    
    // MARK: Helpers
    
    internal class func setCurrentUser(user: User) {
        _currentUser = user
    }
    
    internal class func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        _currentUser = nil
    }
    
}

