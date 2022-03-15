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
    func didTapOnLike(_ superComment: Comments, subComment: CommentsReplies)
    func didTapOnUnlike(_ superComment: Comments, subComment: CommentsReplies)
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
        tableView.estimatedRowHeight = 150
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
        self.likeButton.setTitle("\(commentsData.comment_likes)", for: .normal)
        self.unlikeButton.setTitle("\(commentsData.comment_dislikes)", for: .normal)
        
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
            }
        }
        
    }
    
    @objc fileprivate func likeButtonPressed (_ sender: UIButton)
    {
        guard let mainComment = superComment else {return }

        let obj = replies[sender.tag]
        delegate?.didTapOnLike(mainComment, subComment: obj)

//        if obj.isLiked == nil || obj.isLiked == false
//        {
//            obj.isLiked = true
//        }else {
//            obj.isLiked = nil
//        }
////
        
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        //tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
    }
    
    @objc fileprivate func unLikeButtonPressed (_ sender: UIButton)
    {
        guard let mainComment = superComment else {return }

        let obj = replies[sender.tag]
        delegate?.didTapOnUnlike(mainComment, subComment: obj)

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
        guard let mainComment = superComment else {return }

        let obj = replies[sender.tag]
        delegate?.didTapOnRepliy(mainComment, subComment: obj)
        
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
        
        let obj = replies[indexPath.row]
        cell.config(obj)
        
        cell.likeButton.tag = indexPath.row
        cell.unlikeButton.tag = indexPath.row
        cell.replyButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        cell.unlikeButton.addTarget(self, action: #selector(unLikeButtonPressed(_:)), for: .touchUpInside)
        cell.replyButton.addTarget(self, action: #selector(replyPressed(_:)), for: .touchUpInside)
        
        
        if let like = obj.isLiked {
            
            switch like {
                
            case true:
                self.buttonLiked(cell.likeButton, cell.unlikeButton)
            case false:
                self.buttonDisliked(cell.unlikeButton, cell.likeButton)
            }
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    fileprivate func buttonLiked(_ sender: UIButton, _ disLikedButton: UIButton)
    {
        //sender.setTitleColor(UIColor(hexString: "5BD6CD"), for: .normal)
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.tintColor = .white//UIColor(hexString: "5BD6CD")
        sender.borderColor = UIColor(hexString: "5BD6CD")
        sender.backgroundColor = UIColor(hexString: "5BD6CD")
        
        disLikedButton.setTitleColor(UIColor(hexString: "252C44"), for: .normal)
        disLikedButton.tintColor = UIColor(hexString: "252C44")
        disLikedButton.borderColor = UIColor(hexString: "252C44")
        disLikedButton.backgroundColor = .clear
    }
    
    fileprivate func buttonDisliked(_ sender: UIButton, _ unlikeButton: UIButton)
    {
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.tintColor = .white//UIColor(hexString: "5BD6CD")
        sender.borderColor = UIColor(hexString: "252C44")
        sender.backgroundColor = UIColor(hexString: "252C44")
        
        unlikeButton.setTitleColor(UIColor(hexString: "5BD6CD"), for: .normal)
        unlikeButton.tintColor = UIColor(hexString: "5BD6CD")
        unlikeButton.borderColor = UIColor(hexString: "5BD6CD")
        unlikeButton.backgroundColor = .clear
    }
    
}
