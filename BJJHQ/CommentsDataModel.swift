//
//  CommentsDataModel.swift
//  BJJHQ
//
//  Created by MAC on 10/03/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class CommentsDataModel : Mappable {
    var comments : [Comments]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        comments <- map["comments"]
    }

}

class Comments : Mappable {
    var comment : Comment?
    var comment_likes = 0
    var comment_dislikes = 0
    var commentor_avatar = ""
    var replies : [CommentsReplies]?
    var images = [String]()
    var reaction = ""
    var isLiked : Bool?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        comment <- map["comment"]
        comment_likes <- map["comment_likes"]
        comment_dislikes <- map["comment_dislikes"]
        replies <- map["replies"]
        images <- map["images"]
        commentor_avatar <- map["commentor_avatar"]
        reaction <- map["my_reaction"]
        
        if reaction == "liked" {
            isLiked = true
        }
        else if reaction == "disliked"
        {
            isLiked = false
        }
    }

}


class Comment : Mappable {
    var id = -1
    var name = ""
    var message = ""
    var ancestry = ""
    var user_id = -1
    var created_at = ""
    var updated_at = ""
    var createdDate = Date()
    var updateDate = Date()

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        message <- map["message"]
        ancestry <- map["ancestry"]
        user_id <- map["user_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        
        if let date = created_at.stringToDate("yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            createdDate = date
        }
        
        if let date = updated_at.stringToDate("yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            updateDate = date
        }
    }
}

class CommentsReplies : Mappable {
    var comment : Comment?
    var comment_likes = -1
    var comment_dislikes = -1
    var commentor_avatar = ""
    var replies = [String]()
    var images = [String]()
    var reaction = ""
    var isLiked : Bool?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        comment <- map["comment"]
        comment_likes <- map["comment_likes"]
        comment_dislikes <- map["comment_dislikes"]
        commentor_avatar <- map["commentor_avatar"]
        replies <- map["replies"]
        images <- map["images"]
        reaction <- map["my_reaction"]
        
        if reaction == "liked" {
            isLiked = true
        }
        else if reaction == "disliked"
        {
            isLiked = false
        }
        else {
            isLiked = nil
        }
    }

}
