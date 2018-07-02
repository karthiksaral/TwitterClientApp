//
//  TwitterMention.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation

struct TwitterMention {
    let screen_name: String
    let name: String
}

extension TwitterMention {
    static func load(fromJson json: JSON) -> TwitterMention? {
        guard let screen_name = json["screen_name"] as? String else { return nil }
        guard let name = json["name"] as? String else { return nil }
        
        return TwitterMention(screen_name: screen_name, name: name)
    }
}

extension TwitterMention: Equatable {
    static func == (lhs: TwitterMention, rhs: TwitterMention) -> Bool {
        return lhs.screen_name == rhs.screen_name
    }
}
