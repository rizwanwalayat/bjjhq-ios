//
//  HomeViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 14/02/2022.
//

import UIKit
import PageControls
import iOSDropDown
import ActionCableClient
import CSPieChart

class HomeViewController: BaseViewController,deleteComment {
    func delComment() {
        if isFromDleeteChild {
            commentsParentId = "\(self.superComment?.comment?.id ?? 0)"
            let id = subComment?.comment?.id ?? 0
            let row = self.comments.firstIndex(where: {$0.comment!.id == self.superComment?.comment!.id}) ?? 0
            self.deleteComment(commentId: id, row, true)
            self.isFromDleeteChild = false
        }
        else {
            if let sender = self.deleteButton {
                let obj = comments[sender.tag]
                commentsParentId = "\(obj.comment?.id ?? 0)"
                deleteComment(commentId: obj.comment?.id ?? 0, sender.tag)
                self.deleteButton = nil
            }
        }
    }
    
    
    
    // MARK: - Outlets -
    
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var pagesIndicators: PillPageControl!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var constHeightEquals: NSLayoutConstraint!
    @IBOutlet weak var buyNowButton: UIButton!
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
    @IBOutlet weak var timePieChart: CSPieChart!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables -
    
    var isDetailOpend = true
    var tempColorArray = [UIColor.red, UIColor.orange, UIColor.blue, UIColor.yellow]
    var colorSelectedIndex = IndexPath()
    var comments = [Comments]()
    var viewModel : HomeViewModel?
    var productModel : ProductViewModel?
    var productInfo : ProductInfo?
    var timer = Timer()
    var commentsParentId : String?
    var commentsId : String?
    var isfromEditComment = false
    var isfromChild = false
    var isFromDleeteChild = false
    var superComment: Comments?
    var subComment: CommentsReplies?
    
    var deleteButton : UIButton?
    var size = 0
    var countForRefresh = 0
    // socket related
    let client = ActionCableClient(url: URL(string:"wss://bjjhq.phaedrasolutions.com/cable")!)
    var commentschannel: Channel?
    var reactionsChannel: Channel?
    var currentDealChannel: Channel?
    
    // chartlist
    var dataList = [
        CSPieChartData(key: "time", value: 10),
        CSPieChartData(key: "Empty", value: 10)
    ]
    var colorList: [UIColor] = [
        UIColor(named: "timespaleColor") ?? .magenta,
        .white
    ]
    
    // MARK: - Controller's lifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string:  DataManager.shared.getUser()?.avatar ?? "") {
            self.setImage(imageView: self.userImageComments, url: url)
        }
        self.buyNowButton.backgroundColor = UIColor(hexString: "BDBDBD")
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        setup()
        //        setupClient()
        self.comments.removeAll()
        APICalls()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.removeObserver(self, forKeyPath: "contentSize")
        timer.invalidate()
        //        self.client.disconnect()
        //        self.currentDealChannel?.unsubscribe()
        //        self.commentschannel?.unsubscribe()
        //        self.reactionsChannel?.unsubscribe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.roundCornersTopView(36)
        bottomView.addGradient(colors: [UIColor(hexString: "#DEDFE3").cgColor, UIColor(hexString: "#FFFFFF").cgColor])
        
        
        //        setupClient()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "contentSize"
        {
            if let newvalue = change?[.newKey]{
                let updatedVal  = newvalue as! CGSize
                let viewHeight  = updatedVal.height
                self.constTableViewHeight.constant    = viewHeight
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
        
        let collectionMargin = CGFloat(0)
        let itemSpacing = CGFloat(0)
        let itemHeight = CGFloat(self.collectionView.bounds.height)
        var itemWidth = CGFloat(ScreenSize.SCREEN_WIDTH)
        //var currentItem = 0
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        
        collectionView?.collectionViewLayout = layout
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        
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
        
        
        viewModel = HomeViewModel()
        
        // Pie chart
        timePieChart.delegate = self
        timePieChart.dataSource = self
        timePieChart.pieChartRadiusRate = 0.5
        timePieChart.pieChartLineLength = 12
        
        timePieChart.transform = timePieChart.transform.rotated(by: -90)//CGAffineTransform(rotationAngle: -90)
        
    }
    
    // MARK: - Actions -
    
    @IBAction func menuAction(_ sender: Any) {
        if DataManager.shared.getUser()?.user == nil {
            let vc = DeletePopUpViewController(nibName: "DeletePopUpViewController", bundle: nil)
            vc.coordinator = self.coordinator
            vc.isFromSignIn = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        else {
            openRight()
        }
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
        
        if let comment = writeCommentsTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), comment.count > 0 || imageComment.image != nil {
//        if let comment = writeCommentsTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), comment.count > 0 || imageComment.image != nil {
        if writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            if isfromEditComment {
                editComment(writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            else {
                sendComment(writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                
            }
        } else {
            showToast(message: "Please enter some text")
        }
        }
        
    }
    
    
    @IBAction func crossImageAction(_ sender: Any) {
        
        imageComment.image = nil
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: []) {
            
            self.imageCommentHolder.isHidden = true
        } completion: { animated in
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
        self.view.activityStartAnimating()
        Client.shared.fetchShopURL { url in
            self.view.activityStopAnimating()
            self.presentUIActivityControl(url: url?.absoluteString ?? "BJJHQ")
        }
    }
    @IBAction func butNowAction(_ sender: UIButton) {
        if buyNowButton.backgroundColor != UIColor(hexString: "BDBDBD") {
            let str = "\(Int(self.productInfo?.current_product_id ?? 0) )"
            let uploadedID = str.toBase64()
            coordinator?.myOrderDetail(size, uploadedID, productModel: self.productModel)
        }
        else {
            showToast(message: "Please select size")
        }
    }
    
    @objc func likeButtonPressed (_ sender: UIButton)
    {
        let obj = comments[sender.tag]
        let id = obj.comment?.id ?? 0
        likeComment(commentId: id, sender.tag)
        
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
    }
    
    @objc func unLikeButtonPressed (_ sender: UIButton)
    {
        let obj = comments[sender.tag]
        let id = obj.comment?.id ?? 0
        diLikeComment(commentId: id, sender.tag)
        
        
        //let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadData()//reloadRows(at: [indexpath], with: .automatic)
        
    }
    
    @objc func replyPressed (_ sender: UIButton)
    {
        let obj = comments[sender.tag]
        commentsParentId = "\(obj.comment?.id ?? 0)"
        writeCommentsTF.becomeFirstResponder()
    }
    
    @objc func editPressed (_ sender: UIButton)
    {
        let obj = comments[sender.tag]
        self.commentsId = "\(comments[sender.tag].comment?.id ?? 0)"
        commentsParentId = "\(obj.comment?.id ?? 0)"
        writeCommentsTF.becomeFirstResponder()
        self.isfromEditComment = true
        self.writeCommentsTF.text = obj.comment?.message
    }
    
    @objc func deletePressed (_ sender: UIButton)
    {
        self.deleteButton = sender
        let vc = DeletePopUpViewController(nibName: "DeletePopUpViewController", bundle: nil)
        vc.coordinator = self.coordinator
        vc.delegate = self
        vc.isFromDeleteComment = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    override func imageSelectedFromGalleryOrCamera(selectedImage: UIImage) {
        imageComment.image = selectedImage
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: []) {
            
            self.imageCommentHolder.isHidden = false
        } completion: { animated in
            self.view.layoutIfNeeded()
        }
    }
    
    func pieChartTimeCal()
    {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let date = Date()
        let currentDate = calendar.date(byAdding: .hour, value: 5, to: date) ?? Date()
        
        if let info = productInfo {
            
            //            guard let min = self.timeDifferenceInMin(recent: currentDate, previous: info.lastUpdateDate) else {  return }
            //
            //            dataList = [
            //                CSPieChartData(key: "time", value: Double(min)),
            //                CSPieChartData(key: "Empty", value: Double(info.time_interval))
            //            ]
            
            //            timePieChart.show(animated: true)
            //            timePieChart.reloadPieChart()
            
            guard let endDate = fetchPromotionEndTime(info.lastUpdateDate, minToAdd: info.time_interval) else {return }
            let interval = endDate.timeIntervalSince(currentDate)
            var difference = Date(timeIntervalSinceReferenceDate: interval)
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
                //                self.dataList = [
                //                    CSPieChartData(key: "time", value: Double(min)),
                //                    CSPieChartData(key: "Empty", value: Double(info.time_interval))
                //                ]
                //                self.timePieChart.show(animated: false)
                //                self.timePieChart.reloadPieChart()
                self.countForRefresh = self.countForRefresh + 1
                if self.countForRefresh == 10 {
                    self.viewModel?.fetchCurrentDeal({ success, homeData, message in
                        if let data = homeData, let info = data.response, success {
                            if self.productInfo?.current_product_id != info.current_product_id {
                                self.timer.invalidate()
                                self.productInfo = info
                                self.productDataPopulate(info.current_product_id)
                            }
                        }
                        else {
                            self.showToast(message: message ?? "error")
                        }
                    })
                    self.countForRefresh = 0
                }
                let timeArr = difference.dateToString("HH:mm:ss").components(separatedBy: ":")
                
                self.remainingTimeLabel.text = "\(timeArr[0])h \(timeArr[1])m \(timeArr[2])s"
                difference = Calendar.current.date(byAdding: .second, value: -1, to: difference) ?? difference
            })
            
        }
    }
    
    func timeDifferenceInMin(recent: Date, previous: Date) -> Int? {
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        return minute
    }
    
    func fetchPromotionEndTime(_ byDate : Date, minToAdd: Int) -> Date?
    {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: minToAdd, to: byDate)
        return date
    }
}
