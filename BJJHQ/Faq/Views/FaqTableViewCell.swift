//
//  FaqTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 02/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var expandArrow: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.expandArrow.image = UIImage(named: "Down-Arrow")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func expandCollapse() {
        self.bodyView.isHidden = !self.bodyView.isHidden
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()}, completion: { finished in
            if self.expandArrow.image == UIImage(named: "Down-Arrow")
            {
                self.expandArrow.image = UIImage(named: "up-Arrow")
            }
            else
            {
                self.expandArrow.image = UIImage(named: "Down-Arrow")
            }
        })
    }
    func config(question:String,answer: String, index:Int,section:Int){
        
        self.questionLabel.text = question
        self.answerLabel.text = answer
    }
}
