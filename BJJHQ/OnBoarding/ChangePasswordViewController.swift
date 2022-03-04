//
//  ChangePasswordViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func backAction(_ sender: Any) {
        coordinator?.popVc()
    }
    @IBAction func currentPasswordEyeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.currentPasswordTF.isSecureTextEntry = false
        }
        else {
            self.currentPasswordTF.isSecureTextEntry = true
        }
    }
    @IBAction func newPasswordEyeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.newPasswordTF.isSecureTextEntry = false
        }
        else {
            self.newPasswordTF.isSecureTextEntry = true
        }
        
    }
    @IBAction func confirmPasswordEyeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.confirmPasswordTF.isSecureTextEntry = false
        }
        else {
            self.confirmPasswordTF.isSecureTextEntry = true
        }
    }
    @IBAction func saveChnagesAction(_ sender: Any) {
        Client.shared.changePassword(accessToken: DataManager.shared.getUserAccessToekn()!, password: "HaiderAwan1122") { customer in
            
        }
    }
    
}
