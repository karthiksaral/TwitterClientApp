//
//  TwitterEntity.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 28/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation

struct TwitterEntity {
    let hashtags: [TwitterHashtag]
    let mentions: [TwitterMention]
    let urls: [TwitterURL]
    let medias: [TwitterMedia]
}

extension TwitterEntity {
    static func load(fromJson json: JSON) -> TwitterEntity? {
        var hashtags = [TwitterHashtag]()
        var mentions = [TwitterMention]()
        var urls = [TwitterURL]()
        var medias = [TwitterMedia]()
        
        if let hashtagsJson = json["hashtags"] as? [JSON] {
            for hashtagJson in hashtagsJson {
                if let hashtag = TwitterHashtag.load(fromJson: hashtagJson) {
                    hashtags.append(hashtag)
                }
            }
        }
        
        if let mentionsJson = json["user_mentions"] as? [JSON] {
            for mentionJson in mentionsJson {
                if let mention = TwitterMention.load(fromJson: mentionJson) {
                    mentions.append(mention)
                }
            }
        }
        
        if let urlsJson = json["urls"] as? [JSON] {
            for urlJson in urlsJson {
                if let url = TwitterURL.load(fromJson: urlJson) {
                    urls.append(url)
                }
            }
        }
        
        if let mediasJson = json["media"] as? [JSON] {
            for mediaJson in mediasJson {
                if let media = TwitterMedia.load(fromJson: mediaJson) {
                    medias.append(media)
                }
            }
        }
        
        return TwitterEntity(hashtags: hashtags, mentions: mentions, urls: urls, medias: medias)
    }
}

extension TwitterEntity: Equatable {
    static func == (lhs: TwitterEntity, rhs: TwitterEntity) -> Bool {
        return lhs.hashtags == rhs.hashtags && lhs.mentions == rhs.mentions && lhs.urls == rhs.urls && lhs.medias == rhs.medias
    }
}
