//
//  CommentsTableViewCell.swift
//  BJJHQ
//
//  Created by MAC on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import SDWebImage
var subCommentTableView : CommentsTableViewCell?
protocol commentsTableViewDelegate {
    
    func didTapOnRepliy(_ superComment: Comments, subComment: CommentsReplies)
    func didTapOnLike(_ superComment: Comments, subComment: CommentsReplies)
    func didTapOnUnlike(_ superComment: Comments, subComment: CommentsReplies)
    func didTapOnEdit(_ superComment: Comments, subComment: CommentsReplies,fromChild:Bool)
    func didTapOnDelete(_ superComment: Comments, subComment: CommentsReplies)
}

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownButton: UIButton!
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
    @IBOutlet weak var editDeleteView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageComment: UIImageView!
    
    
    var replies = [CommentsReplies]()
    var superComment : Comments?
    var delegate : commentsTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editDeleteView.isHidden = true
        subCommentTableView = self
        self.replies.removeAll()
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
    @IBAction func dropDownAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            editDeleteView.isHidden = false
            
        }
        else {
            editDeleteView.isHidden = true
        }
    }
    
    func config(_ commentsData : Comments)
    {
        print("calling comment")
        superComment = commentsData
        self.userName.text = commentsData.comment?.name ?? ""
        if let url = URL(string: commentsData.commentor_avatar) {
        setImage(imageView: self.userProfile, url: url)
        }
        self.commentsText.text = commentsData.comment?.message ?? ""
        let time = commentsData.comment?.createdDate.timeCalculation(isShowTime: false)
        self.timeLabel.text =  time
        self.likeButton.setTitle("\(commentsData.comment_likes)", for: .normal)
        self.unlikeButton.setTitle("\(commentsData.comment_dislikes)", for: .normal)

        if let image = commentsData.images.first {
            
            if let url = URL(string: image) {
            self.imageCommentHolder.isHidden = false
            setImage(imageView: self.imageComment, url: url)
            }
        }
        else {
            self.imageCommentHolder.isHidden = true
            self.imageComment.image = nil
        }
        
        if DataManager.shared.getUser()?.user?.id ?? 0 == commentsData.comment?.user_id {
            self.dropDownButton.isHidden = false
        }
        else {
            self.dropDownButton.isHidden = true
            self.editDeleteView.isHidden = true
        }
        
        if let reply =  commentsData.replies{
            if reply.count > 0 {
                replies = reply
                tableView.reloadData()
            }
            else {
                replies.removeAll()
                tableView.reloadData()
            }
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
    
    @objc fileprivate func likeButtonPressed (_ sender: UIButton)
    {
        if let mainComment = superComment {

        let obj = replies[sender.tag]
        delegate?.didTapOnLike(mainComment, subComment: obj)
            if obj.isLiked == nil || obj.isLiked == false
            {
                obj.isLiked = true
            }else {
                obj.isLiked = nil
            }
        }

//
        
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        //tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
    }
    
    @objc fileprivate func unLikeButtonPressed (_ sender: UIButton)
    {
        if let mainComment = superComment {

        let obj = replies[sender.tag]
        delegate?.didTapOnUnlike(mainComment, subComment: obj)
            if obj.isLiked == nil || obj.isLiked == true
            {
                obj.isLiked = false
            }else {
                obj.isLiked = nil
            }
        }
//        

        //let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
        
    }
    
    @objc fileprivate func replyPressed (_ sender: UIButton)
    {
        if let mainComment = superComment {

        let obj = replies[sender.tag]
        delegate?.didTapOnRepliy(mainComment, subComment: obj)
        }
    }
    @objc fileprivate func editPressed (_ sender: UIButton)
    {
        if let mainComment = superComment {

        let obj = replies[sender.tag]
            delegate?.didTapOnEdit(mainComment, subComment: obj, fromChild: true)
        }
    }
    @objc fileprivate func deletePressed (_ sender: UIButton)
    {
        if let mainComment = superComment {

        let obj = replies[sender.tag]
        delegate?.didTapOnDelete(mainComment, subComment: obj)
        }
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
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        cell.unlikeButton.addTarget(self, action: #selector(unLikeButtonPressed(_:)), for: .touchUpInside)
        cell.replyButton.addTarget(self, action: #selector(replyPressed(_:)), for: .touchUpInside)
        cell.editButton.addTarget(self, action: #selector(editPressed(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deletePressed(_:)), for: .touchUpInside)
        
        
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
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.tintColor = .white
        sender.borderColor = UIColor(hexString: "5BD6CD")
        sender.backgroundColor = UIColor(hexString: "5BD6CD")
        
        disLikedButton.setTitleColor(UIColor(hexString: "252C44"), for: .normal)
        disLikedButton.tintColor = UIColor(hexString: "252C44")
        disLikedButton.borderColor = UIColor(hexString: "252C44")
        disLikedButton.backgroundColor = .clear
    }
    
    fileprivate func buttonDisliked(_ sender: UIButton, _ disLikedButton: UIButton)
    {
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.tintColor = .white
        sender.borderColor = UIColor(hexString: "252C44")
        sender.backgroundColor = UIColor(hexString: "252C44")
        
        disLikedButton.setTitleColor(UIColor(hexString: "5BD6CD"), for: .normal)
        disLikedButton.tintColor = UIColor(hexString: "5BD6CD")
        disLikedButton.borderColor = UIColor(hexString: "5BD6CD")
        disLikedButton.backgroundColor = .clear
    }
}
