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

protocol myOrdersAction {
    func selectedAddress(index:Int)
    func editAddress(index:Int)
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
        self.productPrice.text = "\(ordersArray?[index].node.orderNumber ?? 00)"
        self.productNumber.text = "\(ordersArray?[index].node.totalPriceV2.currencyCode.rawValue ?? "$") \(ordersArray?[index].node.totalPriceV2.amount ?? 00)"
        
    }
    
   
}
