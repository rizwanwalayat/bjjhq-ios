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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(index:Int,array:[String]) {
        self.sideMenuImage.image = UIImage(named: "\(index)")
        self.titleLbl.text = array[index]
        
    }

}
