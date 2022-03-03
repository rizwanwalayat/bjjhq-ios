//
//  DeletePopUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class DeletePopUpViewController: BaseViewController {

    
    //MARK: - IBOutlets

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    //@IBOutlet weak var heightMultiplier: NSLayoutConstraint!
    @IBOutlet weak var imgvvView: UIView!
    
    //MARK: - Variables
    var webSocketConnection: WebSocketConnection!
    var isFromSignOut = false
    var isFromAddress = false
    var isFromRemoveCart = false
    var viewModel : DeleteLogoutViewModel?
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        if isFromSignOut {
            //self.heightMultiplier =  heightMultiplier.setMultiplier(multiplier: 0.3)
            self.imgvvView.isHidden = true
            self.titleLbl.text = "Sign Out"
            self.descriptionLbl.text = "Are you sure you want to sign out?"
        }
        else if isFromAddress {
            //self.heightMultiplier =  heightMultiplier.setMultiplier(multiplier: 0.3)
            self.imgvvView.isHidden = true
            self.titleLbl.text = "Delete this Address?"
            self.descriptionLbl.text = "Are you sure you want to delete this address?"
        }
        else if isFromRemoveCart {
           // self.heightMultiplier =  heightMultiplier.setMultiplier(multiplier: 0.3)
            self.imgvvView.isHidden = false
            self.imgView.image = UIImage(named: "ProductSample")
            self.titleLbl.text = ""
            self.titleLbl.isHidden = true
            self.descriptionLbl.text = "This item will be removed from your cart, do you wish to proceed?"
        }
        else {
            // Default
        }
        
        viewModel = DeleteLogoutViewModel()
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
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        hidePopup()
    }
    @IBAction func yesAction(_ sender: Any) {
        if isFromSignOut {
            self.view.activityStartAnimating()
            viewModel?.logoutUser({ success, message in

                if success {
                    DataManager.shared.removeUserAccessToken()
                    Global.shared.socket?.disconnect()
                    self.hidePopup()
                    self.coordinator?.landingPage()
                }
                else {
                    self.showToast(message: message ?? "Somthing went wrong, please try again later")
                }
            })
        }
    }
    
}
