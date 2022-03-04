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
        if (newPasswordTF.text != "") && (confirmPasswordTF.text != "") && (currentPasswordTF.text != "") {
            if newPasswordTF.text == confirmPasswordTF.text {
                guard let user = DataManager.shared.getUser(), let token = DataManager.shared.getUserAccessToekn() else {return}
                APIClient.shared.SignIn(email: user.email, password: self.currentPasswordTF.text ?? "", id: user.shopify_customer_id) { responce, result, error, statusCode, messsage in
                    if error == nil {
                        Client.shared.changePassword(accessToken: token, firstName: user.first_name, lastName: user.last_name, password: self.newPasswordTF.text!) { success, failure in
                            if failure == nil {
                                self.showToast(message: success ?? "Success")
                                APIClient.shared.ChangePassword(email: user.email, newPassword: self.newPasswordTF.text!, confirmPassword: self.confirmPasswordTF.text!, id: user.shopify_customer_id) { responce, result, error, statusCode, messsage in
                                    if let res = result {
                                        self.coordinator?.popVc()
                                        self.showToast(message: res["message"] as! String)
                                    }
                                }
                            }
                            else {
                                self.showToast(message: failure ?? "Failed")
                            }
                        }
                    }
                    
                    else {
                        self.showToast(message: "Current password is wrong")
                    }

                }
                
            }
            else {
                self.showToast(message: "Password not matched")
            }
            }
        else {
            self.showToast(message: "Please fill all fields")
        }
        }

    
}
