//
//  TAConstant.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 21/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation
import UIKit

// MARK: Base URL
 struct TWKeys {
    // consumerKey
    static let TW_ConsumerKey = "IFD0DSgC4KCxt1LTy2d73V8WG"
    // consumerSecret
    static let TW_ConsumerSecret = "gXy5JvvyRTpuhNUi7euIhesjuyS7mHI24wtozmvZaPgE617dJI"
    // base URL
    static let twitterBaseURL = "https://api.twitter.com/"
    
}

// MARK: HTTP Method
struct Method {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
}

// MARK: Request URL
 struct RequestURL {
    static let accessToken = "oauth/access_token"
    static let requestToken = "oauth/request_token"
    static let homeTimeline = "1.1/statuses/home_timeline.json"
    static let mentionsTimeline = "1.1/statuses/mentions_timeline.json"
    static let userTimeline = "1.1/statuses/user_timeline.json"
    static let update = "1.1/statuses/update.json"
    static let accountVerifyCredentials = "1.1/account/verify_credentials.json"
    static let createFavorites = "1.1/favorites/create.json"
    static let destroyFavorites = "1.1/favorites/destroy.json"
    static let trending = "1.1/trends/available.json"
    
    

    static func retweet(_ id: Int64) -> String {
        return "1.1/statuses/retweet/\(id).json"
    }
    static func untweet(_ id: Int64) -> String {
        return "1.1/statuses/unretweet/\(id).json"
    }
    static func authentication(token: String) -> String {
        return "https://api.twitter.com/oauth/authenticate?oauth_token=\(token)"
    }
}

struct TWUserDetails {
    static let TW_UserName =  "user_name"
}

struct TwitterEvents {
    static let StatusPosted = "StatusPosted"
}

//MARK: - Scaling
struct DeviceScale {
    static let SCALE_X = ScreenSize.WIDTH / 375
    static let SCALE_Y = ScreenSize.HEIGHT / 667
}

//MARK: - Screen Size
struct ScreenSize {
    static let WIDTH  = UIScreen.main.bounds.size.width
    static let HEIGHT = UIScreen.main.bounds.size.height
}

