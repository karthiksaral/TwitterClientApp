//
//  TwitterExtendedEntity.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation

struct TwitterExtendedEntity {
    let photos: [TwitterMedia]
}

extension TwitterExtendedEntity {
    static func load(fromJson json: JSON?) -> TwitterExtendedEntity? {
        var photos = [TwitterMedia]()
        
        if let mediasJson = json?["media"] as? [JSON] {
            for mediaJson in mediasJson {
                if let type = mediaJson["type"] as? String, type == "photo" {
                    if let media = TwitterMedia.load(fromJson: mediaJson) {
                        photos.append(media)
                    }
                }
            }
        }
        
        return TwitterExtendedEntity(photos: photos)
    }
}

extension TwitterExtendedEntity: Equatable {
    static func == (lhs: TwitterExtendedEntity, rhs: TwitterExtendedEntity) -> Bool {
        return lhs.photos == rhs.photos
    }
}
