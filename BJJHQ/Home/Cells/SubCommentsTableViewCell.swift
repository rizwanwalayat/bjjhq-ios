//
//  SubCommentsTableViewCell.swift
//  BJJHQ
//
//  Created by MAC on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class SubCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentsText: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var commentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func config(_ commentsData : CommentsReplyData)
    {
        self.userName.text = commentsData.userName
        self.commentsText.text = commentsData.commentText
        self.likeButton.setTitle(commentsData.likeCount, for: .normal)
        self.unlikeButton.setTitle(commentsData.unlikeCount, for: .normal)
        self.timeLabel.text = commentsData.time
        
        if let image = commentsData.commentImage {
            self.imageHolderView.isHidden = false
            self.commentImage.image = image
        }
        else {
            self.imageHolderView.isHidden = true
            self.commentImage.image = nil
        }
        
        if let isLiked = commentsData.isLiked {
            switch isLiked {
            case true:
                
                self.likeButton.setTitleColor(UIColor.white, for: .normal)
                self.likeButton.tintColor = .white
                self.likeButton.borderColor = UIColor(hexString: "5BD6CD")
                self.likeButton.backgroundColor = UIColor(hexString: "5BD6CD")
                
                self.unlikeButton.setTitleColor(UIColor(hexString: "#252C44"), for: .normal)
                self.unlikeButton.tintColor = UIColor(hexString: "#252C44")
                self.unlikeButton.borderColor = UIColor(hexString: "#252C44")
                
            case false:
                
                self.unlikeButton.setTitleColor(UIColor.white, for: .normal)
                self.unlikeButton.tintColor = .white
                self.unlikeButton.borderColor = UIColor(hexString: "#252C44")
                self.unlikeButton.backgroundColor = UIColor(hexString: "#252C44")
                
                self.likeButton.setTitleColor(UIColor(hexString: "5BD6CD"), for: .normal)
                self.likeButton.tintColor = UIColor(hexString: "5BD6CD")
                self.likeButton.borderColor = UIColor(hexString: "5BD6CD")
            }
        }
        
        
    }
}
