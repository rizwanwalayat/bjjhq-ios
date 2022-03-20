//
//  SubCommentsTableViewCell.swift
//  BJJHQ
//
//  Created by MAC on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    
    func config(_ commentsData : CommentsReplies)
    {
        guard let url = URL(string: commentsData.commentor_avatar) else {return }
        setImage(imageView: self.userProfile, url: url)
        self.userName.text = commentsData.comment?.name ?? ""
        self.commentsText.text = commentsData.comment?.message ?? ""
        let time = commentsData.comment?.createdDate.timeCalculation(isShowTime: false)
        self.timeLabel.text =  time
        self.likeButton.setTitle("\(commentsData.comment_likes)", for: .normal)
        self.unlikeButton.setTitle("\(commentsData.comment_dislikes)", for: .normal)
        
        if let image = commentsData.images.first {
            guard let url = URL(string: image) else {return }
            self.imageHolderView.isHidden = false
            setImage(imageView: self.commentImage, url: url)
            //self.imageComment.image = image
        }
        else {
            self.imageHolderView.isHidden = true
            self.commentImage.image = nil
        }
    }
    
    func setImage(imageView:UIImageView,url:URL,placeHolder : String = "default")  {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        
        imageView.sd_setImage(with: url) { (img, err, cahce, URI) in
            imageView.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil {
                imageView.image = img
            } else {
                imageView.image = UIImage(named: placeHolder)
            }
        }
    }
}
