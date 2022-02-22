//
//  SignUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit


class SignUpViewController: BaseViewController {
    
    var viewModel: SignUpViewModel?
        
    //MARK: - IBOutlets
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userNameview: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var checkButtonImageView: UIImageView!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    //MARK: - Functions
    
    func setup() {
        skipButton.setTitle("", for: .normal)
        setupButtonUnderlineText(skipButton, "SKIP", color: "BCBFCC")
        signInButton.setTitle("", for: .normal)
        setupButtonUnderlineText(signInButton, "Sign In", color: "5BD6CD",1.0)
        changeButtonState(state: false)
    }
    
    
    //MARK: - IBAction
    
    @IBAction func visibilityAction(_ sender: UIButton) {
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
    
    @IBAction func signUpAction(_ sender: Any) {
        viewModel?.signUpCustomer(email: emailTF.text!, password: passwordTF.text!, firstName: firstNameTF.text!, lastName: lastNameTF.text!) { customer, error in
            if error != nil {
                self.showToast(message: error ?? "Error")
            }
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        coordinator?.signInPage()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        coordinator?.homePage()
    }
    
    @IBAction func checkButtonAction(_ sender: Any) {
        
        if checkButtonImageView.backgroundColor == .clear {
            checkButtonImageView.backgroundColor = UIColor(hexString: "252C44")
        }
        else {
            checkButtonImageView.backgroundColor = .clear
        }
    }
    
    //MARK: - Functions
    
    func changeButtonState(state:Bool) {
        if state {
            signUpButton.backgroundColor = UIColor(hexString: "#252C44")
        }
        else {
            signUpButton.backgroundColor = UIColor(hexString: "#E2E3E7")
        }
    }
    
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var enable = false

        if firstNameTF.text == "" {
            self.firstNameView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        else {
            self.firstNameView.backgroundColor = UIColor(hexString: "#5BD6CD")
        }
        
        if lastNameTF.text == "" {
            self.lastNameView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        else {
            self.lastNameView.backgroundColor = UIColor(hexString: "#5BD6CD")
        }
        
        if ((emailTF.text?.isValidEmail()) == false) {
            self.emailView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.emailView.backgroundColor = UIColor(hexString: "#5BD6CD")
        }
        
        if userNameTF.text == "" {
            self.userNameview.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.userNameview.backgroundColor = UIColor(hexString: "#5BD6CD")
        }
        
        if passwordTF.text!.count < 8 {
            self.passwordView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.passwordView.backgroundColor = UIColor(hexString: "#5BD6CD")
        }
        


        if passwordTF.text == "" || ((emailTF.text?.isValidEmail()) == false) || userNameTF.text == "" || firstNameTF.text == "" {
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

        print(enable)

        changeButtonState(state: enable)
    }
    
}
