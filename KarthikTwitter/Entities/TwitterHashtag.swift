//
//  TwitterHashtag.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation

struct TwitterHashtag {
    let text: String
}

extension TwitterHashtag {
    static func load(fromJson json: JSON) -> TwitterHashtag? {
        guard let text = json["text"] as? String else { return nil }
        
        return TwitterHashtag(text: text)
    }
}

extension TwitterHashtag: Equatable {
    static func == (lhs: TwitterHashtag, rhs: TwitterHashtag) -> Bool {
        return lhs.text == rhs.text
    }
}
