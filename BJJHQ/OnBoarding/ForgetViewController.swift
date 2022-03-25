//
//  ForgetViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class ForgetViewController: BaseViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var signInBUtton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    //MARK: - Functions
    
    
    func setup() {
        skipButton.setTitle("", for: .normal)
        setupButtonUnderlineText(skipButton, "SKIP", color: "BCBFCC")
        skipButton.setTitle("", for: .normal)
        setupButtonUnderlineText(signInBUtton, "Try signing in again", color: "#5BD6CD",1.0)
        changeButtonState(state: true)
    }
    
    func changeButtonState(state:Bool) {
        if state {
            submitButton.backgroundColor = UIColor(hexString: "#252C44")
        }
        else {
            submitButton.backgroundColor = UIColor(hexString: "#E2E3E7")
        }
    }
    
    //MARK: - IBAction
    
    
    @IBAction func backAction(_ sender: Any) {
        coordinator?.signInPage()
    }
    
    @IBAction func submitAction(_ sender: Any) {

        if emailTF.text!.isValidEmail() && emailTF.text != "" {
            self.view.activityStartAnimating()
            APIClient.shared.checkEmail(email: emailTF.text!) { responce, result, error, statusCode, message in
                self.view.activityStopAnimating()
                let new = result as! [String:String]
                guard let mes = new["message"] else {self.showToast(message: "Error sending email")
                    return }
                print(mes)
                if mes == "email available" {
                    self.view.activityStartAnimating()
                    Client.shared.applyForReset(email: self.emailTF.text ?? "") { done in
                        self.view.activityStopAnimating()
                        self.showAlert(title: "Reset", message: "Please check your email inbox to reset password")
                    }
                }
                else {
                    self.showToast(message: "Email not available")
                }
            }
        }
        else {
            if emailTF.text == "" {
                self.showToast(message: "Please enter email")
            }
            else {
                self.showToast(message: "You have entered an invalid email")
            }
        }
    }
    
    @IBAction func skipAction(_ sender: Any) {
       coordinator?.homePage()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        coordinator?.signInPage()
    }
    
}
extension ForgetViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.emailView.backgroundColor = UIColor(named: "sky")
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.emailView.backgroundColor = UIColor(named: "lightGrey")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
}
