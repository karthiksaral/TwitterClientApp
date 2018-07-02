//
//  TwitterMedia.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation

struct TwitterMedia {
    let id: Int
    let url: URL
    let expanded_url: URL
    let display_url: String
    let media_url_https: URL
    let mediaSize: TwitterSize
}

extension TwitterMedia {
    static func load(fromJson json: JSON) -> TwitterMedia? {
        guard let id = json["id"] as? Int else { return nil }
        guard let urlString = json["url"] as? String, let url = URL(string: urlString) else { return nil }
        guard let expanded_urlString = json["expanded_url"] as? String, let expanded_url = URL(string: expanded_urlString) else { return nil }
        guard let display_url = json["display_url"] as? String else { return nil }
        guard let media_url_httpsString = json["media_url_https"] as? String, let media_url_https = URL(string: "\(media_url_httpsString):small") else { return nil }
        guard let sizes = json["sizes"] as? JSON, let small = sizes["small"] as? JSON, let width = small["w"] as? Int, let height = small["h"] as? Int else { return nil }
        
        let mediaSize = TwitterSize(width: width, height: height)
        
        return TwitterMedia(id: id, url: url, expanded_url: expanded_url, display_url: display_url, media_url_https: media_url_https, mediaSize: mediaSize)
    }
}

extension TwitterMedia: Equatable {
    static func == (lhs: TwitterMedia, rhs: TwitterMedia) -> Bool {
        return lhs.id == rhs.id
    }
}
