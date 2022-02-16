//
//  ColorsSelectionCollectionViewCell.swift
//  BJJHQ
//
//  Created by MAC on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class ColorsSelectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainColoredView: UIView!
    @IBOutlet weak var customColoredView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(_ indexpath : IndexPath, selectedIndexPath : IndexPath, color : UIColor)
    {
        self.customColoredView.layer.cornerRadius = 8
        self.mainColoredView.layer.cornerRadius = self.bounds.height / 2
        
        self.customColoredView.backgroundColor = color
        self.customColoredView.borderColor = .white
        
        if indexpath == selectedIndexPath {
            self.customColoredView.borderWidth = 1
            self.mainColoredView.backgroundColor = color
        }
        else {
            
            self.customColoredView.borderWidth = 0
            self.mainColoredView.backgroundColor = UIColor(hexString: "#B6B6B6", alpha: 0.2)
        }
    }

}
