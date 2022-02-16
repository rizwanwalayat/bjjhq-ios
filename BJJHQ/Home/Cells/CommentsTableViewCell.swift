//
//  CommentsTableViewCell.swift
//  BJJHQ
//
//  Created by MAC on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentsText: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constTableViewHeight: NSLayoutConstraint!
    
    
    var replies = [CommentsReplyData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "SubCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "SubCommentsTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        print("observeValue called in tableview cell")
        
        if keyPath == "contentSize"
        {
            if let newvalue = change?[.newKey]{
                let updatedVal  = newvalue as! CGSize
                let viewHeight  = updatedVal.height
                constTableViewHeight.constant = viewHeight
                tableView.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }
    
    func config(_ commentsData : CommentsData)
    {
        self.userName.text = commentsData.userName
        self.commentsText.text = commentsData.commentText
        self.likeButton.setTitle(commentsData.likeCount, for: .normal)
        self.unlikeButton.setTitle(commentsData.unlikeCount, for: .normal)
        self.timeLabel.text = commentsData.time
        
        replies = commentsData.replies
        tableView.reloadData()
    }
}


extension CommentsTableViewCell: UITableViewDelegate
{
    
}

extension CommentsTableViewCell: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCommentsTableViewCell", for: indexPath) as! SubCommentsTableViewCell
        
        cell.config(replies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
