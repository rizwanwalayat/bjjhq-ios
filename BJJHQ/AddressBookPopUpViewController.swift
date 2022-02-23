//
//  AddressBookPopUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class AddressBookPopUpViewController: BaseViewController {
    
    
    //MARK: - IBOutlets

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var postalView: UIView!
    @IBOutlet weak var postalTF: UITextField!
    @IBOutlet weak var districtView: UIView!
    @IBOutlet weak var address1View: UIView!
    @IBOutlet weak var address2View: UIView!
    @IBOutlet weak var districtTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    //MARK: - Variables
    
    var isfromAddNewAddress = false
    var textForNow = ""
    var descriptionMessage : String?
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.textColor = UIColor.init(hexString: "000000", alpha: 0.25)
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
    
    @IBAction func deletePopupAction(_ sender: Any) {
        let vc = DeletePopUpViewController(nibName: "DeletePopUpViewController", bundle: nil)
        vc.isFromAddress = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    

}

extension AddressBookPopUpViewController: UITextViewDelegate,UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor(named: "blue")
        textView.text = ""
        if self.textForNow != "" {
            textView.text = textForNow
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textForNow = textView.text
        if textView.text == "" {
            textView.text = "Address1"
            textView.textColor = UIColor.init(hexString: "000000", alpha: 0.25)
        }
        
    }
    
}
