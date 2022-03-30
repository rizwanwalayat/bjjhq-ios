//
//  SignInViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    var viewModel: SignInViewModel?
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    //MARK: - Functions
    func setup() {
        skipButton.setTitle("", for: .normal)
        setupButtonUnderlineText(skipButton, "SKIP", color: "BCBFCC")
        signupButton.setTitle("", for: .normal)
        setupButtonUnderlineText(signupButton, "Sign Up", color: "5BD6CD",1.0)
        changeButtonState(state: true)
    }
    
    func changeButtonState(state:Bool) {
        if state {
            signInButton.backgroundColor = UIColor(hexString: "#252C44")
        }
        else {
            signInButton.backgroundColor = UIColor(hexString: "#E2E3E7")
        }
    }
    
    //MARK: - IBAction
    
    
    @IBAction func passwordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.passwordTF.isSecureTextEntry = false
        }
        else {
            self.passwordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        coordinator?.welcomePage()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if emailTF.text != "" && passwordTF.text != "" {
            if ((emailTF.text?.isValidEmail()) != nil) {
                if passwordTF.text?.count ?? 0 >= 8 {
                    apiCall()
                }
                else {
                    self.showToast(message: " Password must be Minimum 8 characters at least 1 Alphabet and 1 Number ", ScreenSize.SCREEN_HEIGHT, 60)
                }
            }
            else {
                self.showToast(message: "You have entered an invalid email")
            }
        }
        else {
            self.showToast(message: "Please fill all fields")
        }

    }
    
    func apiCall() {
        self.view.activityStartAnimating()
        viewModel?.signInCustomer(email: emailTF.text!, password: passwordTF.text!,  completion: { data, error in

            self.view.activityStopAnimating()

            if let accessToken = data {

                DataManager.shared.saveUserAccessToken(value: accessToken)
                self.coordinator?.successController()
            }

            if error != nil {
                self.view.activityStopAnimating()
                self.showToast(message: error ?? "Error")
            }
        })
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        coordinator?.signUpPage(signupType: SignupType.manual)
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        coordinator?.forgetPage()
    }
    
    @IBAction func skipAction(_ sender: Any) {

        self.view.activityStartAnimating()
        viewModel?.guestUser( { success in

            self.view.activityStopAnimating()
            if success {

                self.coordinator?.homePage()
            }
        })
    }
    
}

extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            self.emailView.backgroundColor = UIColor(named: "sky")
            self.passwordView.backgroundColor = UIColor(named: "lightGrey")
        }
        else {
            self.emailView.backgroundColor = UIColor(named: "lightGrey")
            self.passwordView.backgroundColor = UIColor(named: "sky")
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.emailView.backgroundColor = UIColor(named: "lightGrey")
        self.passwordView.backgroundColor = UIColor(named: "lightGrey")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
}
