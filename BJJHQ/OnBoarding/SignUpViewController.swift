//
//  SignUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

protocol SignUpControllerDelegate: AnyObject {
    func signUpCustomer(email: String, password: String, firstName: String, lastName: String )
}

class SignUpViewController: BaseViewController {
    var viewModel = SignUpViewModel()
    
    
    weak var delegate: SignUpControllerDelegate?
    
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
        setupButtonUnderlineText(signInButton, "Sign In", color: "#DF6565",1.0)
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
        viewModel.signUpCustomer(email: emailTF.text!, password: passwordTF.text!, firstName: firstNameTF.text!, lastName: lastNameTF.text!)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        coordinator?.signInPage()
    }
    
    @IBAction func skipAction(_ sender: Any) {
//        coordinator?.homePage()
    }
    
    
    //MARK: - Functions
    
    func changeButtonState(state:Bool) {
        if state {
            signUpButton.backgroundColor = UIColor(hexString: "DF6565")
        }
        else {
            signUpButton.backgroundColor = UIColor(hexString: "#E2E3E7")
        }
    }
    
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var enable = false

        if firstNameTF.text == "" {
            self.firstNameView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        else {
            self.firstNameView.backgroundColor = UIColor(hexString: "#DF6565")
        }
        
        if lastNameTF.text == "" {
            self.lastNameView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        else {
            self.lastNameView.backgroundColor = UIColor(hexString: "#DF6565")
        }
        
        if ((emailTF.text?.isValidEmail()) == false) {
            self.emailView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.emailView.backgroundColor = UIColor(hexString: "#DF6565")
        }
        
        if userNameTF.text == "" {
            self.userNameview.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.userNameview.backgroundColor = UIColor(hexString: "#DF6565")
        }
        
        if passwordTF.text!.count < 8 {
            self.passwordView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.passwordView.backgroundColor = UIColor(hexString: "#DF6565")
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
