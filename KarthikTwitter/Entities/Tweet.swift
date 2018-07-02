//
//  Tweet.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation
/*
struct Tweet {
    let id: Int
    let text: String
    let created_at: Date
    let favorited: Bool
    let retweet_count: Int
    let retweeted: Bool
    let favorite_count: Int
    let user: User?
    let entities: TwitterEntity?
    let extendedEntities: TwitterExtendedEntity?
}

extension Tweet {
    static func load(fromJson json: JSON) -> Tweet? {
        guard let id = json["id"] as? Int else { return nil }
        guard let text = json["text"] as? String else { return nil }
        guard let created_at_string = json["created_at"] as? String, let created_at = dateFormatter.date(from: created_at_string) else { return nil }
        guard let favorited = json["favorited"] as? Bool else { return nil }
        guard let retweet_count = json["retweet_count"] as? Int else { return nil }
        guard let retweeted = json["retweeted"] as? Bool else { return nil }
        guard let favorite_count = json["favorite_count"] as? Int else { return nil }
     
        guard let userJson = json["user"] as? JSON else { return nil }
        guard let entitiesJson = json["entities"] as? JSON else { return nil }
        
        let extendedEntitiesJson: JSON? = json["extended_entities"] as? JSON
        
        return Tweet(id: id, text: text, created_at: created_at, favorited: favorited, retweet_count: retweet_count, retweeted: retweeted, favorite_count: favorite_count, user: User.load(fromJson: userJson), entities: TwitterEntity.load(fromJson: entitiesJson), extendedEntities: TwitterExtendedEntity.load(fromJson: extendedEntitiesJson))
    }
}

extension Tweet: Equatable {
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
}
*/
internal class Tweet: NSObject {
    
    internal typealias ImageDimension = (width: Int, height: Int)
    
    // MARK: Stored Properties
    
    private(set) var user: User?
    private(set) var createdAt: Date?
    private(set) var text: String?
    private(set) var retweetCount: Int = 0
    private(set) var favoritesCount: Int = 0
    private(set) var mediaURL: URL?
    private(set) var isRetweetedTweet: Bool = false
    private(set) var inReplyToScreenName: String?
    private(set) var retweetSourceUser: User?
    private(set) var id: Int64?
    private(set) var mediaImageSize: (large: ImageDimension?, medium: ImageDimension?, small: ImageDimension?)?
    
    internal var isFavorited: Bool = false
    internal var isRetweeted: Bool = false
    
    // MARK: Initializers
    
    init(dictionary: [String: Any]) {
        if let userDict = dictionary["user"] as? [String: Any] {
            user = User(dictionary: userDict)
        }
        
        if let timeStampString = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: timeStampString)
        }
        
        if let entities = dictionary["entities"] as? [String: Any], let media = entities["media"] as? [[String: Any]] {
            if let mediaURL = media[0]["media_url_https"] as? String, let mediaType = media[0]["type"] as? String, mediaType == "photo" {
                if let sizes = media[0]["sizes"] as? [String: Any]  {
                    if let largeSize = sizes["large"] as? [String: Any] {
                        let height = largeSize["h"] as? NSNumber
                        let width = largeSize["w"] as? NSNumber
                        mediaImageSize?.large? = (width: Int(width ?? 0), height: Int(height ?? 0))
                    }
                    
                    if let mediumSize = sizes["medium"] as? [String: Any] {
                        let height = mediumSize["h"] as? NSNumber
                        let width = mediumSize["w"] as? NSNumber
                        mediaImageSize?.medium? = (width: Int(width ?? 0), height: Int(height ?? 0))
                    }
                    
                    if let smallSize = sizes["small"] as? [String: Any] {
                        let height = smallSize["h"] as? NSNumber
                        let width = smallSize["w"] as? NSNumber
                        mediaImageSize?.small? = (width: Int(width ?? 0), height: Int(height ?? 0))
                    }
                }
                self.mediaURL = URL(string: mediaURL)
            }
        }
        
        id = dictionary["id"] as? Int64
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        if let replyScreenName = dictionary["in_reply_to_screen_name"] as? String {
            inReplyToScreenName = replyScreenName
        }
        
        if let retweetStatus = dictionary["retweeted_status"] as? NSDictionary {
            // it's a retweeted tweet
            isRetweetedTweet = true
            if let userDictionary = retweetStatus["user"] as? [String : Any] {
                retweetSourceUser = User(dictionary: userDictionary )
            }
        }
        
        isFavorited = (dictionary["favorited"] as? NSNumber ?? 0) != 0
        isRetweeted = (dictionary["retweeted"] as? NSNumber ?? 0) != 0
    }
    
    // MARK: Helpers    
    internal class func tweets(from dictionaries: [[String : Any]]) -> [Tweet] {
        return dictionaries.map {Tweet(dictionary: $0)}
    }
    
    internal func setRetweetsCount(_ count: Int) {
        self.retweetCount = count
    }
    
    internal func setFavCount(_ count: Int) {
        self.favoritesCount = count
    }
}
