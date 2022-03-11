//
//  AddressTableViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import Pay
import Buy
import SDWebImage

protocol myOrdersAction {
}

class MyOrdersTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNumber: UILabel!
    @IBOutlet weak var productDetail: UILabel!
    @IBOutlet weak var productDay: UILabel!
    @IBOutlet weak var productTime: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var delegate : myOrdersAction?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    //MARK: - Functions
    
    func config(ordersArray : [Storefront.OrderEdge]?, index : Int) {
        if let url = ordersArray?[index].node.lineItems.edges[0].node.variant?.image?.originalSrc {
            self.setImage(imageView: self.productImage, url: url)
        }
        
        self.productPrice.text = "$ \(ordersArray?[index].node.totalPriceV2.amount ?? 00)"
        self.productNumber.text = "Order #\(ordersArray?[index].node.orderNumber ?? 00)"
        guard let date = ordersArray?[index].node.processedAt else {return}
        self.productDay.text = returnDay(date: date)
        self.productTime.text = returnTime(date: date)
        self.productDetail.text = "\(ordersArray?[index].node.lineItems.edges[0].node.title ?? "")"
    }
    
    func setImage(imageView:UIImageView,url:URL,placeHolder : String = "dummy")  {
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
    
    func returnDay(date:Date?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE"
        
        let returningValue = formatter.string(from: date!)
        return returningValue
    }
    
    func returnTime(date:Date?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "h:mm a"
        let returningValue = formatter.string(from: date!)
        return returningValue
    }
    
//    func returnTime(date:Date?) -> String {
//        let hour = Calendar.current.component(.hour, from: date!)
//        let minutes = Calendar.current.component(.minute, from: date!)
//        return "\(hour):\(minutes)"
//    }
}

