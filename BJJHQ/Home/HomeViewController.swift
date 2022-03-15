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
    @IBOutlet weak var timePieChart: CSPieChart!
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

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        setup()
        APICalls()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.removeObserver(self, forKeyPath: "contentSize")
        timer.invalidate()
        self.client.disconnect()
        self.currentDealChannel?.unsubscribe()
        self.commentschannel?.unsubscribe()
        self.reactionsChannel?.unsubscribe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.roundCornersTopView(36)
        bottomView.addGradient(colors: [UIColor(hexString: "#DEDFE3").cgColor, UIColor(hexString: "#FFFFFF").cgColor])
        

        setupClient()
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
        
        // Pie chart
        timePieChart.delegate = self
        timePieChart.dataSource = self
        timePieChart.pieChartRadiusRate = 0.5
        timePieChart.pieChartLineLength = 12
        
        timePieChart.transform = timePieChart.transform.rotated(by: -90)//CGAffineTransform(rotationAngle: -90)
        
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
        
        if writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            
            sendComment(writeCommentsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines))
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
    
    @IBAction func butNowAction(_ sender: Any) {
        
        
//        coordinator?.myOrderDetail()
//        
//        let vc = OrderViewController()
//        vc.coordinator = self.coordinator
//        vc.orderDetail = self.ordersArray?[indexPath.row]
//        self.coordinator?.navigationController.pushViewController(vc, animated: true)
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
        if let info = productInfo {
            
            guard let min = self.timeDifferenceInMin(recent: Date(), previous: info.lastUpdateDate) else {  return }
            
            dataList = [
                CSPieChartData(key: "time", value: Double(min)),
                CSPieChartData(key: "Empty", value: Double(info.time_interval))
            ]
            
            timePieChart.show(animated: true)
            timePieChart.reloadPieChart()
            
            guard let endDate = fetchPromotionEndTime(info.lastUpdateDate, minToAdd: info.time_interval) else {return }
            
            let interval = endDate.timeIntervalSince(Date())
            var difference = Date(timeIntervalSinceReferenceDate: interval)
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
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


