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
        setupButtonUnderlineText(signupButton, "Sign Up", color: "#DF6565",1.0)
        changeButtonState(state: false)
    }
    
    func changeButtonState(state:Bool) {
        if state {
            signInButton.backgroundColor = UIColor(hexString: "DF6565")
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
        viewModel?.signInCustomer(email: emailTF.text!, password: passwordTF.text!,  completion: { data, error in
            if error != nil {
                self.showToast(message: error ?? "Error")
            }
        })
    
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        coordinator?.signUpPage()
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        coordinator?.forgetPage()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        coordinator?.homePage()
    }
    
}

extension SignInViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var enable = false
        if ((emailTF.text?.isValidEmail()) == false) {
            self.emailView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.emailView.backgroundColor = UIColor(hexString: "#DF6565")
        }
        
        if passwordTF.text!.count < 8 {
            self.passwordView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.passwordView.backgroundColor = UIColor(hexString: "#DF6565")
        }
        
        if passwordTF.text == "" || ((emailTF.text?.isValidEmail()) == false) {
            enable = false
        }

        else {
            if passwordTF.text!.count < 8 {
                enable = false
            }
            else {
                enable = true
            }
        }
        
        changeButtonState(state: enable)
    }
    
}
