//
//  HomeCollectionViewCell.swift
//  BJJHQ
//
//  Created by MAC on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(_ model : ImageViewModel?){
        
        if let data = model {
            
            productImageView.sd_imageIndicator?.startAnimatingIndicator()
            
            SDWebImageDownloader.shared.downloadImage(with: data.url) { image, data, error, success in
                
                self.productImageView.sd_imageIndicator?.stopAnimatingIndicator()
                if let image = image {
                    self.productImageView.image = image
                }
                else {
                    self.productImageView.image = UIImage(named: "image DUmmy")
                }
            }
        }
        else {
            productImageView.image = UIImage(named: "image DUmmy")
        }

    }

}
