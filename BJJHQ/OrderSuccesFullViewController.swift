//
//  OrderSuccesFullViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class OrderSuccesFullViewController: BaseViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var buttonHeighwt: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewMultiplier: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: - Variables
    var isFromFeedBack = false
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        if isFromFeedBack {
            self.titleLbl.text = "Thank you for your feedback!"
            self.descriptionLbl.text = "Your message has been received, we really appreciate you for submitting your feedback"
            self.buttonHeighwt.constant = 0
            mainViewMultiplier =  mainViewMultiplier.setMultiplier(multiplier: 0.45)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDidappear()
    }
    
    
    //MARK: - Functions
    
    func setupDidappear() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
            self.popUpView.transform = .identity
        })
        
    }
    
    func hidePopup() {
        popUpView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }) { (success) in
            
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
    //MARK: - IBAction
    
    
    @IBAction func crossAction(_ sender: Any) {
            hidePopup()
            coordinator?.homePage()
        
    }
    
    @IBAction func homeAction(_ sender: Any) {
            coordinator?.homePage()
    }
    
}
