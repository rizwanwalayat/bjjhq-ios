//
//  CommentsDataModel.swift
//  BJJHQ
//
//  Created by MAC on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import Foundation
import UIKit

class CommentsData : NSObject
{
    var userName = ""
    var commentText = ""
    var likeCount = ""
    var unlikeCount = ""
    var time = ""
    var commentImage : UIImage?
    var isLiked : Bool?
    var replies = [CommentsReplyData]()
    
    override init() {
        super.init()
    }
    
    init(_ userName: String, _ comments: String, _ likeCount : String, _ unlikeCount: String, _ time: String,_ commentImage: UIImage?, _ replies : [CommentsReplyData], _ isLiked : Bool? ) {
        
        self.userName = userName
        self.commentText = comments
        self.likeCount = likeCount
        self.unlikeCount = unlikeCount
        self.time = time
        self.commentImage = commentImage
        self.replies = replies
        self.isLiked = isLiked
    }
}


class CommentsReplyData : NSObject
{
    var userName = ""
    var commentText = ""
    var likeCount = ""
    var unlikeCount = ""
    var time = ""
    var commentImage : UIImage?
    var isLiked: Bool?
    
    override init() {
        super.init()
    }
    
    init(_ userName: String, _ comments: String, _ likeCount : String, _ unlikeCount: String, _ time: String, _ commentImage: UIImage?, _ isLiked : Bool?) {
        
        self.userName = userName
        self.commentText = comments
        self.likeCount = likeCount
        self.unlikeCount = unlikeCount
        self.time = time
        self.commentImage = commentImage
        self.isLiked = isLiked
    }
}
