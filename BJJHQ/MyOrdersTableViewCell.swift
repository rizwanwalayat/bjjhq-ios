//
//  AddressTableViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
protocol myOrdersAction {
    func selectedAddress(index:Int)
    func editAddress(index:Int)
}

class MyOrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    var delegate : myOrdersAction?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
}
