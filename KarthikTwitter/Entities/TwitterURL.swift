//
//  TwitterURL.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation

struct TwitterURL {
    let url: URL
    let expanded_url: URL
    let display_url: String
}

extension TwitterURL {
    static func load(fromJson json: JSON) -> TwitterURL? {
        guard let urlString = json["url"] as? String, let url = URL(string: urlString) else { return nil }
        guard let expanded_urlString = json["expanded_url"] as? String, let expanded_url = URL(string: expanded_urlString) else { return nil }
        guard let display_url = json["display_url"] as? String else { return nil }
        
        return TwitterURL(url: url, expanded_url: expanded_url, display_url: display_url)
    }
}

extension TwitterURL: Equatable {
    static func == (lhs: TwitterURL, rhs: TwitterURL) -> Bool {
        return lhs.expanded_url == rhs.expanded_url
    }
}
