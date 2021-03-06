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
    @IBOutlet weak var currentPasswordBottomLine: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPasswordTF.delegate = self
        newPasswordTF.delegate = self
        confirmPasswordTF.delegate = self
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
                self.view.activityStartAnimating()
                    Client.shared.login(email: user.user?.email ?? "", password: self.currentPasswordTF.text ?? "") { accessToken, error in
                    self.view.activityStopAnimating()
                    if error == nil {
                        self.view.activityStartAnimating()
                        Client.shared.changePassword(accessToken: token, firstName: user.user?.first_name ?? "", lastName: user.user?.last_name ?? "", password: self.newPasswordTF.text!) { success, failure in
                            self.view.activityStopAnimating()
                            if failure == nil {
                                self.view.activityStartAnimating()
                                self.showToast(message: success ?? "Success")
                                APIClient.shared.ChangePassword(email: user.user?.email ?? "", newPassword: self.newPasswordTF.text!, confirmPassword: self.confirmPasswordTF.text!, id: user.user?.shopify_customer_id ?? "") { responce, result, error, statusCode, messsage in
                                    self.view.activityStopAnimating()
                                    if let res = result {
                                        self.coordinator?.welcomePage()
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
                        if let _ = error {
                            if error! == "Wrong email or password" {
                                self.showAlert(title: "Error", message: "Please enter valid current password")
                                self.currentPasswordBottomLine.backgroundColor = .red
                            }
                            else {
                                self.showToast(message: error! )
                            }
                        }
                        else {
                            self.showToast(message: error ?? "Wrong password" )
                        }
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

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string ==  " "{
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == currentPasswordTF {
            self.currentPasswordBottomLine.backgroundColor = UIColor(named: "sky")
        }
    }
}
