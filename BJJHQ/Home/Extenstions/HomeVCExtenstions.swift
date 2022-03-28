//
//  HomeVCExtenstions.swift
//  BJJHQ
//
//  Created by MAC on 04/03/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import Foundation
import UIKit
import ActionCableClient
import CSPieChart
import ObjectMapper
import Buy
import AVFAudio


// MARK: - CollectionView Delegate  -

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            let height = self.collectionView.bounds.height
            let size = CGSize(width: ScreenSize.SCREEN_WIDTH, height: height)
            return size
        }
        
        // for colors
        return CGSize(width: 22, height: 22)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if collectionView == self.collectionView {
            let index = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
            self.pageControl.currentPage = Int(index)
//            pagesIndicators.progress = index
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorsCollectionView{
            
            self.colorSelectedIndex = indexPath
        }
        else if collectionView == self.collectionView {
            var pictures = [CollieGalleryPicture]()
            if self.productModel?.images.items.count ?? 0 > 0 {
                if let itemsOfPicture = self.productModel?.images.items {
                    for i in itemsOfPicture {
                        pictures.append(CollieGalleryPicture(url: i.url.absoluteString, placeholder: UIImage.init(named: "AppDefulter")!, title: i.url.lastPathComponent, caption: "BJJHQ"))
                    }
                }
                
                let gallery = CollieGallery(pictures: pictures)
                gallery.presentInViewController(self)
            }

        }
        
        // for colors
        self.colorsCollectionView.reloadData()
        
    }
}

// MARK: - CollectionView Data Source  -

extension HomeViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            
            return self.productModel?.images.items.count ?? 0
        }
        
        // for colors
        return tempColorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
            
            if let item = self.productModel?.images.items[indexPath.item] {
                
                self.setImage(imageView: cell.productImageView, url: item.url)
            }
                
            //cell.config(item)
            
            
            return cell
        }

        // for colors
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsSelectionCollectionViewCell", for: indexPath) as! ColorsSelectionCollectionViewCell

        cell.configCell(indexPath, selectedIndexPath: colorSelectedIndex, color: tempColorArray[indexPath.item])
        return cell
        
    }
}


// MARK: - TableView Delegate  -

extension HomeViewController : UITableViewDelegate {
    
    
}

// MARK: - TableView Data Source  -

extension HomeViewController: UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.register(CommentsTableViewCell.self, indexPath: indexPath)
        let obj = comments[indexPath.row]
        cell.config(obj)
        cell.likeButton.tag = indexPath.row
        cell.unlikeButton.tag = indexPath.row
        cell.replyButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        cell.unlikeButton.addTarget(self, action: #selector(unLikeButtonPressed(_:)), for: .touchUpInside)
        cell.replyButton.addTarget(self, action: #selector(replyPressed(_:)), for: .touchUpInside)
        
        cell.delegate = self
        
        cell.likeButton.setTitleColor(UIColor(hexString: "5BD6CD"), for: .normal)
        cell.likeButton.tintColor = UIColor(hexString: "5BD6CD")
        cell.likeButton.borderColor = UIColor(hexString: "5BD6CD")
        cell.likeButton.backgroundColor = .clear

        cell.unlikeButton.setTitleColor(UIColor(hexString: "252C44"), for: .normal)
        cell.unlikeButton.tintColor = UIColor(hexString: "252C44")
        cell.unlikeButton.borderColor = UIColor(hexString: "252C44")
        cell.likeButton.backgroundColor = .clear
        
        if let like = obj.isLiked {
            
            switch like {
                
            case true:
                self.buttonLiked(cell.likeButton, cell.unlikeButton)
            case false:
                self.buttonDisliked(cell.likeButton, cell.unlikeButton)
            }
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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


// MARK: - Custom TableView Delegate  -

extension HomeViewController : commentsTableViewDelegate {
    
    func didTapOnLike(_ superComment: Comments, subComment: CommentsReplies) {
        
        
        commentsParentId = "\(superComment.comment?.id ?? 0)"
        let id = subComment.comment?.id ?? 0
        
        let row = self.comments.firstIndex(where: {$0.comment!.id == superComment.comment!.id}) ?? 0
    
        self.likeComment(commentId: id, row, true)
    }
    
    func didTapOnUnlike(_ superComment: Comments, subComment: CommentsReplies) {
        commentsParentId = "\(superComment.comment?.id ?? 0)"
        let id = subComment.comment?.id ?? 0
        
        let row = self.comments.firstIndex(where: {$0.comment!.id == superComment.comment!.id}) ?? 0
        
        self.diLikeComment(commentId: id, row, true)
    }
    
    func didTapOnRepliy(_ superComment: Comments, subComment: CommentsReplies) {
        
        commentsParentId = "\(superComment.comment?.id ?? 0)"
        if writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            
            sendComment(writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    
}


// MARK: - API Calls -

extension HomeViewController {
    
    func APICalls()
    {
        /// Product Fetch
        ///
        self.view.activityStartAnimating()
        viewModel?.fetchCurrentDeal({ success, homeData, message in
            self.view.activityStopAnimating()
            if let data = homeData, let info = data.response, success {
                
                self.productInfo = info
                
                self.productDataPopulate(info.current_product_id)
            }
            else {
                self.showToast(message: message ?? "error")
            }
        })
        
        fetchComments()
        

    }
    func fetchComments() {
        self.view.activityStartAnimating()
        viewModel?.fetchComments({ success, data, message in
            self.view.activityStopAnimating()
            if success, let commentsData = data?.comments {
                self.comments.removeAll()
                self.comments = commentsData
                self.tableView.reloadData()
                subCommentTableView?.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if self.comments.count > 0 {
                        let indexpAth = IndexPath(row: self.comments.count - 1, section: 0)
                        self.tableView.reloadRows(at: [indexpAth], with: .automatic)
                        print("relaod data after delegate")
                        self.tableView.reloadData()
                        subCommentTableView?.tableView.reloadData()
                    }
                }
                
            }
        })
    }
    
    func sendComment(_ text : String)
    {
        let parentId = commentsParentId ?? ""
        
        if let image = imageComment.image {
            
            viewModel?.sendImageComment(parentId, text, image: image, { success, message in
                
                if success {
                    self.fetchComments()
                    self.writeCommentsTF.text = ""
                    self.commentsParentId = nil
                    
                    self.imageComment.image = nil
                    
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: []) {
                        
                        self.imageCommentHolder.isHidden = true
                    } completion: { animated in
                        self.view.layoutIfNeeded()
                    }
                }
            })
        }
        else {
            
            viewModel?.sendComments(parentId, text, { success, message in
                if success {
                    
                    self.writeCommentsTF.text = ""
                    self.commentsParentId = nil
                    self.fetchComments()
                }
            })
        }
        
    }
    
    func likeComment(commentId: Int, _ ofIndex: Int, _ isSubComment: Bool = false)
    {
        viewModel?.likeComment(commentId, { success, message in
           
            if success {
               
                let obj = self.comments[ofIndex]
                if !isSubComment {
                    obj.isLiked = true
                }
                else {
                    if let row = obj.replies?.firstIndex(where: {$0.comment!.id == commentId})
                    {
                        let replyObj = obj.replies?[row]
                        replyObj?.isLiked = false
                    }
                }
                let indexpath = IndexPath(row: ofIndex, section: 0)
                self.tableView.reloadRows(at: [indexpath], with: .automatic)
            }
            self.fetchComments()
        })
    }
    
    func diLikeComment(commentId: Int, _ ofIndex: Int, _ isSubComment: Bool = false)
    {
        
        viewModel?.disLikeComment(commentId, { success, message in
            if success {
                let obj = self.comments[ofIndex]
                if !isSubComment {
                    obj.isLiked = true
                }
                else {
                    if let row = obj.replies?.firstIndex(where: {$0.comment!.id == commentId})
                    {
                        let replyObj = obj.replies?[row]
                        replyObj?.isLiked = false
                    }
                }
                let indexpath = IndexPath(row: ofIndex, section: 0)
                self.tableView.reloadRows(at: [indexpath], with: .automatic)
            }
            
            self.fetchComments()
        })
    }
    func editComment(commentId: Int, _ ofIndex: Int, _ isSubComment: Bool = false)
    {
        
        viewModel?.editComment(commentId, { success, message in
            if success {
                let obj = self.comments[ofIndex]
                if !isSubComment {
                    obj.isLiked = true
                }
                else {
                    if let row = obj.replies?.firstIndex(where: {$0.comment!.id == commentId})
                    {
                        let replyObj = obj.replies?[row]
                        replyObj?.isLiked = false
                    }
                }
                let indexpath = IndexPath(row: ofIndex, section: 0)
                self.tableView.reloadRows(at: [indexpath], with: .automatic)
            }
            
            self.fetchComments()
        })
    }
    func deleteComment(commentId: Int, _ ofIndex: Int, _ isSubComment: Bool = false)
    {
        
        viewModel?.deleteComment(commentId, { success, message in
            if success {
                let obj = self.comments[ofIndex]
                if !isSubComment {
                    obj.isLiked = true
                }
                else {
                    if let row = obj.replies?.firstIndex(where: {$0.comment!.id == commentId})
                    {
                        let replyObj = obj.replies?[row]
                        replyObj?.isLiked = false
                    }
                }
                let indexpath = IndexPath(row: ofIndex, section: 0)
                self.tableView.reloadRows(at: [indexpath], with: .automatic)
            }
            
            self.fetchComments()
        })
    }
    
    func productDataPopulate(_ productID: Double)
    {
        let id = productID as NSNumber
        self.pieChartTimeCal()
        
        self.viewModel?.fetchProducts(id.stringValue, { pdata in
            
            if let data = pdata {
  
                if let obj = data.items.first(where: { self.decodeId(id: $0.id) == id.stringValue }) {
                    
                    self.productModel = obj
                    
                    var titleArray = [String]()
                    var updatedTitleArray = [String]()
                    var quantity = [Int32]()
                    var ids = [Int]()
                    var updatedIds = [Int]()
                    
                    for (value,item) in obj.variants.items.enumerated() {
                        self.size = value
                        titleArray.append(item.title)
                        quantity.append(item.model.node.quantityAvailable ?? 0)
                        ids.append(Int(value))
                    }
                    
                    for (quantity,value) in quantity.enumerated() {
                        
                        if value > 0 {
                            updatedTitleArray.append(titleArray[quantity])
                            updatedIds.append(ids[quantity])
                        }
                    }
                    
                    self.dropDownTF.optionArray = updatedTitleArray
                    //Its Id Values and its optional
                    self.dropDownTF.optionIds = updatedIds
//                    self.buyNowButton.backgroundColor = UIColor(hexString: "BDBDBD")
                    // The the Closure returns Selected Index and String
                    self.dropDownTF.didSelect{(selectedText , index ,id) in
                        self.size = id
                        self.dropDownFilled.text = selectedText
                        self.buyNowButton.backgroundColor = UIColor(named: "blue")
                        
                    }
                }
                else {
                    
                    self.productModel = data.items.last
                }
                
                self.pagesIndicators.pageCount = self.productModel?.images.items.count ?? 0
//                self.pagesIndicators.contentMode = .center
//                self.pagesIndicators.clipsToBounds = true
                self.pageControl.numberOfPages = self.productModel?.images.items.count ?? 0
                self.productTitle.text = self.productModel?.title ?? ""
                self.productPrice.text = self.productModel?.price ?? ""
                let summary =  self.productModel?.summary ?? ""
                self.descriptionDetial.text = summary.htmlToString
                self.tableView.reloadData()
                subCommentTableView?.tableView.reloadData()
                self.collectionView.reloadData()
            }
        })
    }
}



// MARK: - Web Socket  -

extension HomeViewController {
    
    func setupClient() {
        
        self.client.willConnect = {
            print("Will Connect")
        }
        
        self.client.onDisconnected = {(error: ConnectionError?) in
            print("Disconected with error: \(String(describing: error))")
        }
        
        self.client.willReconnect = {
            print("Reconnecting to \(self.client.url)")
            return true
        }
        
        
        self.client.onConnected = {
            print("Connected to \(self.client.url)")
                        
            
            
            // comments Channel
            let room_identifier = ["room" : "comment_channel"]
            self.commentschannel = self.client.create("CommentsChannel", identifier: room_identifier, autoSubscribe: true, bufferActions: true)
            
            
            
            // reactions Channel
            
            let reactionIdentifier = ["room": "reaction_channel"]
            self.reactionsChannel =  self.client.create("ReactionsChannel", identifier: reactionIdentifier, autoSubscribe: true, bufferActions: true)
            
            
            
            // currentDeal Channel
            
            let currentDealIdentifier = ["room": "deal_channel"]
            self.currentDealChannel =  self.client.create("DealChannel", identifier: currentDealIdentifier, autoSubscribe: true, bufferActions: true)
                    self.commentsChannelsListener()
                    self.reactionsChannelsListener()
                    self.dealsChannelsListener()
        }
        
        let token = DataManager.shared.getUserAccessToekn() ?? ""
        client.headers = [
            "Authorization": token,
            "Accept": "application/json"
        ]
       
        self.client.connect()
    }
}

// MARK: - Pie Chart Related  -

extension HomeViewController : CSPieChartDataSource, CSPieChartDelegate {
    func numberOfComponentData() -> Int {
        dataList.count
    }
    
    func pieChart(_ pieChart: CSPieChart, dataForComponentAt index: Int) -> CSPieChartData {
        dataList[index]
    }
    
    func numberOfComponentColors() -> Int {
        colorList.count
    }
    
    func pieChart(_ pieChart: CSPieChart, colorForComponentAt index: Int) -> UIColor {
        colorList[index]
    }
    
}


// MARK: - Channel Listners  -

extension HomeViewController  {
    func commentsChannelsListener() {
        
        
        self.commentschannel?.onSubscribed = {
            print("Subscribed to Comments Channel")
        }
        
        self.commentschannel?.onReceive = {(data: Any?, error: Error?) in
            self.fetchComments()
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//            if let response = data as? [String:Any]
//            {
//                print(response)
//                if let comment = response["comment"] as? [String: Any], let ancestry = comment["ancestry"] as? NSNumber {
//
//                    if let row = self.comments.firstIndex(where: {$0.comment!.id == ancestry.intValue}) {
//                        let obj = self.comments[row]
//                        if let data = Mapper<CommentsReplies>().map(JSONObject: response ) {
//                            obj.replies?.append(data)
//                        }
//                        self.comments[row] = obj
//
//                        let indexpath = IndexPath(row: row, section: 0)
//                        self.tableView.reloadRows(at: [indexpath], with: .automatic)
//                    }
//
//                    if let commentObj = self.comments.first( where: {$0.comment!.id == ancestry.intValue} ) {
//
//                        if let data = Mapper<CommentsReplies>().map(JSONObject: response ) {
//                            commentObj.replies?.append(data)
//                        }
//                    }
//                }
//                else if let data = Mapper<Comments>().map(JSONObject: response ) {
//
//                    self.comments.append(data)
//
//                    let indexpath = IndexPath(row: self.comments.count - 1, section: 0)
//                    self.tableView.reloadRows(at: [indexpath], with: .automatic)
//                }
//
//                self.tableView.reloadData()
//            }
        }
        
        self.commentschannel?.onUnsubscribed = {
            print("Unsubscribed")
        }
        
        self.commentschannel?.onRejected = {
            print("Rejected")
        }
    }
    
    func reactionsChannelsListener() {
        
        
        self.reactionsChannel?.onSubscribed = {
            print("Subscribed to reaction Channel")
        }
        
        self.reactionsChannel?.onReceive = {(data: Any?, error: Error?) in
            self.fetchComments()
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            if let response = data as? [String:Any]
//            {
//                print(response)
//                if let reacton = response["reaction"] as? [String: Any], let comment = reacton["comment"] as? [String:Any], let commentId =  reacton["comment_id"] as? NSNumber, let isLikedString = reacton["reaction"] as? String {
//
//                    var isLiked = false
//                    if isLikedString == "liked" {
//                        isLiked = true
//                    }
//                    else if isLikedString == "disliked"
//                    {
//                        isLiked = false
//                    }
//
//                    if let ancestry = comment["ancestry"] as? NSNumber {
//
//                        if let row = self.comments.firstIndex(where: {$0.comment!.id == ancestry.intValue}) {
//
//                            let obj = self.comments[row]
//
//                            if let replyRow = obj.replies?.firstIndex(where: {$0.comment!.id == commentId.intValue}) {
//
//                                let subObj = obj.replies?[replyRow]
//                                subObj?.isLiked = isLiked
//                            }
//                            let indexpath = IndexPath(row: row, section: 0)
//                            self.tableView.reloadRows(at: [indexpath], with: .automatic)
//                        }
//                    }
//                    else {
//
//                        if let row = self.comments.firstIndex(where: {$0.comment!.id == commentId.intValue}) {
//
//                            let obj = self.comments[row]
//                            obj.isLiked = isLiked
//                            let indexpath = IndexPath(row: row, section: 0)
//                            self.tableView.reloadRows(at: [indexpath], with: .automatic)
//                        }
//
//                    }
//
//                }
//                //self.tableView.reloadData()
//            }
        }
        
        self.reactionsChannel?.onUnsubscribed = {
            print("Unsubscribed")
        }
        
        self.reactionsChannel?.onRejected = {
            print("Rejected")
        }
    }
    
    func dealsChannelsListener() {
        
        
        self.currentDealChannel?.onSubscribed = {
            print("Subscribed to deals Channel")
        }
        
        self.currentDealChannel?.onReceive = {(data: Any?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = data as? [String:Any] {
                print(response)
                if let data = Mapper<ProductInfo>().map(JSONObject: response) {
                    
                    self.productInfo = data
                    
                    self.productDataPopulate(data.current_product_id)
                }
            }
            
        }
        
        self.currentDealChannel?.onUnsubscribed = {
            print("Unsubscribed")
        }
        
        self.currentDealChannel?.onRejected = {
            print("Rejected")
        }
    }
    
}
