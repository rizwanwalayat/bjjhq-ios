//
//  SideMenuTableViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var sideMenuImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var array = ["Change Password","My Orders","Address Book","Contact Us","Notifications","Return Policy","FAQ's"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(index:Int) {
        self.sideMenuImage.image = UIImage(named: "\(index)")
        self.titleLbl.text = self.array[index]
        
    }

}
