//
//  CommentsReactions.swift
//  BJJHQ
//
//  Created by MAC on 14/03/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//


import Foundation
import ObjectMapper

class CommentsReactions : Mappable {
    var reaction : Reaction?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        reaction <- map["reaction"]
    }
}

class Reaction : Mappable {
    var comment : Comment?
    var comment_id : Int?
    var reaction : String?
    var reactor_system_id : Int?
    var isLiked : Bool?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        comment <- map["comment"]
        comment_id <- map["comment_id"]
        reaction <- map["reaction"]
        reactor_system_id <- map["reactor_system_id"]
        
        if reaction == "liked" {
            isLiked = true
        }
        else if reaction == "disliked"
        {
            isLiked = false
        }
    }

}

