//
//  CommentsTableViewCell.swift
//  BJJHQ
//
//  Created by MAC on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

protocol commentsTableViewDelegate {
    
    func didTapOnRepliy(_ superComment: Comments, subComment: CommentsReplies)
}

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
    @IBOutlet weak var imageCommentHolder: UIView!
    @IBOutlet weak var imageComment: UIImageView!
    
    
    var replies = [CommentsReplies]()
    var superComment : Comments?
    var delegate : commentsTableViewDelegate?
    
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
                DispatchQueue.main.async {
                    self.tableView.layoutIfNeeded()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func config(_ commentsData : Comments)
    {
        superComment = commentsData
        self.userName.text = commentsData.comment?.name ?? ""
        self.commentsText.text = commentsData.comment?.message ?? ""
        let time = commentsData.comment?.createdDate.timeCalculation(isShowTime: false)
        self.timeLabel.text =  time
        //        self.likeButton.setTitle(commentsData.likeCount, for: .normal)
        //        self.unlikeButton.setTitle(commentsData.unlikeCount, for: .normal)
        
//        if let image = commentsData.commentImage {
//            self.imageCommentHolder.isHidden = false
//            self.imageComment.image = image
//        }
//        else {
//            self.imageCommentHolder.isHidden = true
//            self.imageComment.image = nil
//        }
        
        if let reply =  commentsData.replies{
            if reply.count > 0 {
                replies = reply
                tableView.reloadData()
                
//                DispatchQueue.main.async {
//                    let contentSize = self.tableView.contentSize.height
//                    self.constTableViewHeight.constant = contentSize
//                    self.layoutIfNeeded()
//                }
            }
        }
        
    }
    
    @objc fileprivate func likeButtonPressed (_ sender: UIButton)
    {
//        let obj = superComment.replies[sender.tag]
//
//
//        if obj.isLiked == nil || obj.isLiked == false
//        {
//            obj.isLiked = true
//        }else {
//            obj.isLiked = nil
//        }
//
        
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
    }
    
    @objc fileprivate func unLikeButtonPressed (_ sender: UIButton)
    {
//        let obj = superComment.replies[sender.tag]
//        
//        
//        if obj.isLiked == nil || obj.isLiked == true
//        {
//            obj.isLiked = false
//        }else {
//            obj.isLiked = nil
//        }
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
        
    }
    
    @objc fileprivate func replyPressed (_ sender: UIButton)
    {
        
        //delegate?.didTapOnRepliy(superComment, subComment: replies[sender.tag])
//        let obj = comments[sender.tag]
//        replayComment = obj
//        writeCommentsTF.text = obj.userName
//        writeCommentsTF.becomeFirstResponder()
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
        
        cell.likeButton.tag = indexPath.row
        cell.unlikeButton.tag = indexPath.row
        cell.replyButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        cell.unlikeButton.addTarget(self, action: #selector(unLikeButtonPressed(_:)), for: .touchUpInside)
        cell.replyButton.addTarget(self, action: #selector(replyPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
