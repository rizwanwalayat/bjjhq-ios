//
//  AddressTableViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
protocol addressAction {
    func selectedAddress(index:Int)
    func editAddress(index:Int)
}

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    var delegate : addressAction?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func radioAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.selectedAddress(index: sender.tag)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        delegate?.editAddress(index: sender.tag)
    }
}
