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
            pagesIndicators.progress = index
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorsCollectionView{
            
            self.colorSelectedIndex = indexPath
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
            
            let item = self.productModel?.images.items[indexPath.row]
                
            cell.config(item)
            
            
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        
        cell.config(comments[indexPath.row])
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
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Custom TableView Delegate  -

extension HomeViewController : commentsTableViewDelegate {
    func didTapOnRepliy(_ superComment: Comments, subComment: CommentsReplies) {
        
        replayComment = superComment
        writeCommentsTF.becomeFirstResponder()
    }
    
}


// MARK: - API Calls -

extension HomeViewController {
    
    func APICalls()
    {
        /// Product Fetch
        viewModel?.fetchCurrentDeal({ success, homeData, message in
            
            if let data = homeData, let info = data.response, success {
                
                self.productInfo = info
                
                self.productDataPopulate(info.current_product_id)
            }
            else {
                self.showToast(message: message ?? "Data not fetched ")
            }
        })
        
        viewModel?.fetchComments({ success, data, message in
            
            if success, let commentsData = data?.comments {
                self.comments = commentsData
                self.tableView.reloadData()
            }
        })
        
        viewModel?.fetchReactions({ success, data, message in
            if success {
                print(data!, message!)
            }
        })
    }
    
    func sendComment(_ text : String)
    {
        let parentId = commentsParentId ?? ""
        viewModel?.sendComments(parentId, text, { success, message in
            if success {
                self.writeCommentsTF.text = ""
                self.commentsParentId = nil
            }
        })
        
    }
    
    func likeComment(commentId: Int)
    {
        viewModel?.likeComment(commentId, { success, data, message in
            if success {
                print(data!, message!)
                self.writeCommentsTF.text = ""
            }
        })
    }
    
    func diLikeComment(commentId: Int)
    {
        viewModel?.disLikeComment(commentId, { success, data, message in
            if success {
                print(data!, message!)
                self.writeCommentsTF.text = ""
            }
        })
    }
    
    fileprivate func productDataPopulate(_ productID: Double)
    {
        let id = "\(productID)"
        self.pieChartTimeCal()
        
        self.viewModel?.fetchProducts(id, { pdata in
            
            if let data = pdata {
                
                self.productModel = data.items.first
                if let obj = data.items.first(where: { self.decodeId(id: $0.id) == id }) {
                    
                    self.productModel = obj
                }
                
                //self.pagesIndicators.pageCount = self.productModel?.images.items.count ?? 0
                self.productTitle.text = self.productModel?.title ?? ""
                self.productPrice.text = self.productModel?.price ?? ""
                self.descriptionDetial.text = self.productModel?.summary ?? ""
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
            self.commentsChannelsListener()
            
            
            // reactions Channel
            
            let reactionIdentifier = ["room": "reaction_channel"]
            self.reactionsChannel =  self.client.create("ReactionsChannel", identifier: reactionIdentifier, autoSubscribe: true, bufferActions: true)
            self.reactionsChannelsListener()
            
            
            // currentDeal Channel
            
            let currentDealIdentifier = ["room": "deal_channel"]
            self.currentDealChannel =  self.client.create("DealChannel", identifier: currentDealIdentifier, autoSubscribe: true, bufferActions: true)
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
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = data as? [String:Any]
            {
                if let comment = response["comment"] as? [String: Any], let ancestry = comment["ancestry"] as? NSNumber {
                    
                    if let row = self.comments.firstIndex(where: {$0.comment!.id == ancestry.intValue}) {
                        let obj = self.comments[row]
                        if let data = Mapper<CommentsReplies>().map(JSONObject: response ) {
                            obj.replies?.append(data)
                        }
                        self.comments[row] = obj
                    }
                    
//                    if let commentObj = self.comments.first( where: {$0.comment!.id == ancestry.intValue} ) {
//
//                        if let data = Mapper<CommentsReplies>().map(JSONObject: response ) {
//                            commentObj.replies?.append(data)
//                        }
//                    }
                }
                else if let data = Mapper<Comments>().map(JSONObject: response ) {

                    self.comments.append(data)
                }
                
                self.tableView.reloadData()
            }
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
            if let error = error {
                print(error.localizedDescription)
                return
            }
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
