//
//  AddressBookPopUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import ADCountryPicker

var globalAddressBookPopUp : AddressBookPopUpViewController?

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
    var refreshTrue = false
    var isfromAddNewAddress = false
    var textForNow = ""
    var descriptionMessage : String?
    var getAddress : Addresses?
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalAddressBookPopUp = self
        self.textView.textColor = UIColor.init(hexString: "000000", alpha: 0.25)
        self.popUpView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        if isfromAddNewAddress {
            self.titleLbl.text = "Add New Address"
            self.deleteButton.isHidden = true
            self.saveButton.setTitle("Save this Address", for: .normal)
        }
        else {
            
            setup()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDidappear()
    }
    
    
    //MARK: - Functions
    
    func setup() {
        self.countryTF.text = getAddress?.country
        self.cityTF.text = getAddress?.city
        self.postalTF.text = getAddress?.zip
        self.districtTF.text = getAddress?.district
        self.textView.text = getAddress?.address1
        
        if !isfromAddNewAddress {
        if self.textView.text != "" {
            self.textView.textColor = UIColor(named: "blue")
        }}
        self.addressTF.text = getAddress?.address2
        
    }
    
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
    
    func showCountryPicker(){
        
        let picker = ADCountryPicker()
        picker.showCallingCodes = false
        picker.defaultCountryCode = getAddress?.country ?? "US"
        picker.font = UIFont(name: "NeusaNextStd-CompactRegular", size: 15)
        picker.searchBarBackgroundColor = UIColor.lightGray

        picker.didSelectCountryClosure = { name, code in
       
            self.countryTF.text = name
            picker.dismiss(animated: true, completion: nil)
        }
        
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func crossAction(_ sender: Any) {
        hidePopup()
    }
    
    @IBAction func deletePopupAction(_ sender: Any) {
        let vc = DeletePopUpViewController(nibName: "DeletePopUpViewController", bundle: nil)
        vc.isFromAddress = true
        vc.getAddress = self.getAddress
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if self.textView.text != "" && self.countryTF.text != "" && self.postalTF.text != "" && self.cityTF.text != "" && self.districtTF.text != "" {
            
            if isfromAddNewAddress {
                self.view.activityStartAnimating()
                Client.shared.addAddress(accessToken: DataManager.shared.getUserAccessToekn()!, address1: self.textView.text!, address2: self.addressTF.text!, country: self.countryTF.text!, postalCode: self.postalTF.text!, city: self.cityTF.text!, province: self.districtTF.text!) { pass, fail in
                    self.view.activityStopAnimating()
                    self.hidePopup()
                    globalMyAddressesViewController?.setup()
                }
        }
            else {
                self.view.activityStartAnimating()
                Client.shared.updateSelectedAddress(accessToken: DataManager.shared.getUserAccessToekn()!, address1: self.textView.text!, address2: self.addressTF.text!, country: self.countryTF.text!, postalCode: self.postalTF.text!, city: self.cityTF.text!, province: self.districtTF.text!, id: self.getAddress?.id ?? "") { pass, fail in
                    self.view.activityStopAnimating()
                    self.hidePopup()
                    globalMyAddressesViewController?.setup()
                }
            }
        } else {
            showToast(message: "Please fill all the fields")
        }
    }
    @IBAction func countryPickerAction(_ sender: Any) {
        showCountryPicker()
    }
    
    
}

extension AddressBookPopUpViewController: UITextViewDelegate,UITextFieldDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if isfromAddNewAddress {
        textView.textColor = UIColor(named: "blue")
        textView.text = ""
        if self.textForNow != "" {
            textView.text = textForNow
        }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if isfromAddNewAddress {
        self.textForNow = textView.text
        if textView.text == "" {
            textView.text = "Address1"
            textView.textColor = UIColor.init(hexString: "000000", alpha: 0.25)
        }
        }
    }
    
}
