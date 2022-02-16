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
    var replies = [CommentsReplyData]()
    
    override init() {
        super.init()
    }
    
    init(_ userName: String, _ comments: String, _ likeCount : String, _ unlikeCount: String, _ time: String, _ replies : [CommentsReplyData] ) {
        
        self.userName = userName
        self.commentText = comments
        self.likeCount = likeCount
        self.unlikeCount = unlikeCount
        self.time = time
        self.replies = replies
    }
}


class CommentsReplyData : NSObject
{
    var userName = ""
    var commentText = ""
    var likeCount = ""
    var unlikeCount = ""
    var time = ""
    
    override init() {
        super.init()
    }
    
    init(_ userName: String, _ comments: String, _ likeCount : String, _ unlikeCount: String, _ time: String ) {
        
        self.userName = userName
        self.commentText = comments
        self.likeCount = likeCount
        self.unlikeCount = unlikeCount
        self.time = time
    }
}
