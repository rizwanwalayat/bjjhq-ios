//
//  NotificationHoursCollectionViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
protocol getTimeForDeals {
    func timeForDealsNotification(time:Int)
}
class NotificationHoursCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    var array = [2,4,6,8,10,12]
    var delegate : getTimeForDeals?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(index:Int) {
        
        self.titleLbl.text = "\(String(array[index])) hrs"
    }
}
