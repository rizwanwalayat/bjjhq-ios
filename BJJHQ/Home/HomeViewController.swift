//
//  HomeViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 14/02/2022.
//

import UIKit
import PageControls
import iOSDropDown

class HomeViewController: BaseViewController {

    
    // MARK: - Outlets -
    
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var pagesIndicators: PillPageControl!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var constHeightEquals: NSLayoutConstraint!
    @IBOutlet weak var sizeHolderView: UIView!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var dropDownTF: DropDown!
    @IBOutlet weak var dropDownFilled: UITextField!
    @IBOutlet weak var colorsHolderView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var descriptionHolderView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionDetial: UILabel!
    @IBOutlet weak var commentsHolderView: UIView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var userImageComments: UIImageView!
    @IBOutlet weak var writeCommentsTF: UITextField!
    @IBOutlet weak var addCommebtImageBtn: UIButton!
    @IBOutlet weak var imageCommentHolder: UIView!
    @IBOutlet weak var imageComment: UIImageView!
    @IBOutlet weak var sendCommentsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constTableViewHeight: NSLayoutConstraint!
    
    // MARK: - Variables -
    
    var isDetailOpend = true
    var tempColorArray = [UIColor.red, UIColor.orange, UIColor.blue, UIColor.yellow]
    var colorSelectedIndex = IndexPath()
    var comments = [CommentsData]()
    var replayComment : CommentsData?
    var webSocketConnection: WebSocketConnection!
    var viewModel : HomeViewModel?
    var productModel : ProductViewModel?
    
    
    // MARK: - Controller's lifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        addCommentsData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.roundCornersTopView(36)
        bottomView.addGradient(colors: [UIColor(hexString: "#DEDFE3").cgColor, UIColor(hexString: "#FFFFFF").cgColor])
        
//        webSocketConnection = WebSocketTaskConnection(url: URL(string: "wss://bjjhq.phaedrasolutions.com/cable")!)
//        webSocketConnection.delegate = self
//
//        webSocketConnection.connect()
        
        //webSocketConnection.send(text: "ping")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        print("observeValue called")
        
        if keyPath == "contentSize"
        {
            if let newvalue = change?[.newKey]{
                let updatedVal  = newvalue as! CGSize
                let viewHeight  = updatedVal.height
                constTableViewHeight.constant    = viewHeight
                DispatchQueue.main.async {
                    self.tableView.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // MARK: - Custom Methods -
    
    fileprivate func setup()
    {
        // Collection View related
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        colorsCollectionView.register(UINib(nibName: "ColorsSelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorsSelectionCollectionViewCell")
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        // bottomView curve
        
        bottomView.roundCornersTopView(36)
        bottomView.addGradient(colors: [UIColor(hexString: "#DEDFE3").cgColor, UIColor(hexString: "#FFFFFF").cgColor])
        
        // button emplty text
        menuButton.setTitle("", for: .normal)
        upButton.setTitle("", for: .normal)
        sizeButton.setTitle("", for: .normal)
        sendCommentsBtn.setTitle("", for: .normal)
        addCommebtImageBtn.setTitle("", for: .normal)
        sizeButton.transform = self.upButton.transform.rotated(by: .pi)
        upButton.transform = self.upButton.transform.rotated(by: .pi)
        
        
        // dropdown integrations
        
        dropDownTF.optionArray = ["Small", "Medium", "Large", "X Large", " XX Large"]
        //Its Id Values and its optional
        dropDownTF.optionIds = [1,2,3,4, 5]

        // The the Closure returns Selected Index and String
        dropDownTF.didSelect{(selectedText , index ,id) in
            self.dropDownFilled.text = selectedText
            //self.dropDownTF.text = ""
        }
        
        viewModel = HomeViewModel()
        viewModel?.fetchCurrentDeal({ success, homeData, message in
            
            if let data = homeData, let info = data.response, success {
                
                let id = "\(info.current_product_id)"
                
//                self.viewModel?.fetchSignleProduct(id, { pdata in
//                    if let data = pdata {
//                        print(data.title )
//                    }
//                })
                
                self.viewModel?.fetchProducts(id, { pdata in

                    if let data = pdata {
                        
                        self.productModel = data.items.first
                        self.productTitle.text = self.productModel?.title ?? ""
                        self.productPrice.text = self.productModel?.price ?? ""
                        self.descriptionLabel.text = self.productModel?.summary ?? ""
                        
                        //print(data.items.first?.title ?? "")
                    }
                })
            }
            
            self.showToast(message: message ?? "Data not fetched ")
        })
    }
    
    
    fileprivate func addCommentsData()
    {
        let commentsObject = CommentsData("Rizwan07", "very nice", "10", "15", "3 min",  nil, [], nil)
        comments.append(commentsObject)
        
        let subComments = CommentsReplyData("Rizwan07", "great", "100", "2", "30 min", nil, nil)
        let commentsObject2 = CommentsData("Haider003", "good", "100", "300", "1 hour",  nil, [subComments], nil)
        comments.append(commentsObject2)
        
        let subComments1 = CommentsReplyData("Haider003", "Thank you so much for these kind words.", "100", "2", "30 min", nil, nil)
        let commentsObject3 = CommentsData("asad01", "Amazing hoodies!! Just received my first order and they are fantastic quality and perfect fit.", "33", "0", "1 day", nil , [subComments, subComments1], nil)
        comments.append(commentsObject3)
        
        tableView.reloadData()
    }
    
    // MARK: - Actions -
    
    @IBAction func menuAction(_ sender: Any) {
        openRight()
    }
    
    @IBAction func upButtonAction(_ sender: Any) {
        
        var multiplier = 0.4
        
        isDetailOpend ? (multiplier = 0.6) : (multiplier = 0.4)
        
        let const = constHeightEquals.setMultiplier(multiplier: multiplier)
        constHeightEquals = const
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: []) {
            self.view.layoutIfNeeded()
            self.upButton.transform = self.upButton.transform.rotated(by: .pi)
            self.collectionView.reloadData()
        } completion: { completed in
            
            self.isDetailOpend = !self.isDetailOpend
           
        }

    }
    @IBAction func uploadImageAction(_ sender: Any) {
        
        ImagePickerVC.shared.showImagePickerFromVC(fromVC: self)
    }
    
    @IBAction func sendCommentsAction(_ sender: Any) {
        
        var  index = comments.count - 1
        
        if writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            
            webSocketConnection.send(text: writeCommentsTF.text!)
        }
//            if let commentObj = replayComment{
//
//                let subComments = CommentsReplyData("unknown", writeCommentsTF.text ?? "Nothing", "0", "0", "Now", imageComment.image, nil)
//                commentObj.replies.append(subComments)
//
//                index = comments.firstIndex{$0 === commentObj} ?? comments.count - 1
//            }
//            else {
//
//                let commentsObject = CommentsData("unknown", writeCommentsTF.text ?? "Nothing", "0", "0", "Now",  imageComment.image, [], nil)
//                comments.append(commentsObject)
//                index = comments.count - 1
//            }
//        }
//
//        crossImageAction(imageComment!)
//        writeCommentsTF.text = ""
//        replayComment = nil
//        tableView.reloadData()
//        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
        
    }
    
    @IBAction func crossImageAction(_ sender: Any) {
        
        imageComment.image = nil
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: []) {
            
            self.imageCommentHolder.isHidden = true
        } completion: { animated in
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func butNowAction(_ sender: Any) {
        
        
        coordinator?.myOrderDetail()
    }
    
    @objc func likeButtonPressed (_ sender: UIButton)
    {
        let obj = comments[sender.tag]
        
        if obj.isLiked == nil || obj.isLiked == false
        {
            obj.isLiked = true
        }else {
            obj.isLiked = nil
        }
        
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
    }
    
    @objc func unLikeButtonPressed (_ sender: UIButton)
    {
        let obj = comments[sender.tag]
        
        
        if obj.isLiked == nil || obj.isLiked == true
        {
            obj.isLiked = false
        }else {
            obj.isLiked = nil
        }
    
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
        
    }
    
    @objc func replyPressed (_ sender: UIButton)
    {
        let obj = comments[sender.tag]
        replayComment = obj
        writeCommentsTF.text = obj.userName
        writeCommentsTF.becomeFirstResponder()
    }
    
    override func imageSelectedFromGalleryOrCamera(selectedImage: UIImage) {
        imageComment.image = selectedImage
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: []) {
            
            self.imageCommentHolder.isHidden = false
        } completion: { animated in
            self.view.layoutIfNeeded()
        }
    }
}

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
        
        
        if let isLiked = comments[indexPath.row].isLiked {
            if isLiked {
                
                cell.likeButton.setTitleColor(UIColor.white, for: .normal)
                cell.likeButton.tintColor = .white
                cell.likeButton.borderColor = UIColor(hexString: "5BD6CD")
                cell.likeButton.backgroundColor = UIColor(hexString: "5BD6CD")
                
                cell.unlikeButton.setTitleColor(UIColor(hexString: "#252C44"), for: .normal)
                cell.unlikeButton.tintColor = UIColor(hexString: "#252C44")
                cell.unlikeButton.borderColor = UIColor(hexString: "#252C44")
                cell.unlikeButton.backgroundColor = .clear
                
            }
            else {
                
                cell.unlikeButton.setTitleColor(UIColor.white, for: .normal)
                cell.unlikeButton.tintColor = .white
                cell.unlikeButton.borderColor = UIColor(hexString: "#252C44")
                cell.unlikeButton.backgroundColor = UIColor(hexString: "#252C44")
                
                cell.likeButton.setTitleColor(UIColor(hexString: "5BD6CD"), for: .normal)
                cell.likeButton.tintColor = UIColor(hexString: "5BD6CD")
                cell.likeButton.borderColor = UIColor(hexString: "5BD6CD")
                cell.likeButton.backgroundColor = .clear
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Custom TableView Delegate  -

extension HomeViewController : commentsTableViewDelegate {
    func didTapOnRepliy(_ superComment: CommentsData, subComment: CommentsReplyData) {
        
        replayComment = superComment
        writeCommentsTF.text = subComment.userName
        writeCommentsTF.becomeFirstResponder()
    }
    
}

// MARK: - Web Socket Delegate  -

extension HomeViewController : WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection) {
        print("Connected")
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        if let error = error {
            print("Disconnected with error:\(error)")
        } else {
            print("Disconnected normally")
        }
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        print("Connection error:\(error)")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        print("Text message: \(text)")
        Global.shared.socket = connection
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.webSocketConnection.send(text: "ping")
//        }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        print("Data message: \(data)")
    }
    
    
}
