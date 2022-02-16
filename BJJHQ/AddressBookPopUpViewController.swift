//
//  AddressBookPopUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class AddressBookPopUpViewController: BaseViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var isfromAddNewAddress = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popUpView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        if isfromAddNewAddress {
            self.titleLbl.text = "Add New Address"
            self.deleteButton.isHidden = true
            self.saveButton.setTitle("Save this Address", for: .normal)
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
    @IBAction func crossAction(_ sender: Any) {
        hidePopup()
    }
    

}
