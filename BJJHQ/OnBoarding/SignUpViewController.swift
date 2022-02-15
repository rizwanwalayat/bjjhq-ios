//
//  SignUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userNameview: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
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
        coordinator?.popVc()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
    }
    
    @IBAction func skipAction(_ sender: Any) {
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var enable = false

        if fullNameTF.text == "" {
            self.fullNameView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.fullNameView.backgroundColor = UIColor(hexString: "#DF6565")
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
        


        if passwordTF.text == "" || ((emailTF.text?.isValidEmail()) == false) || userNameTF.text == "" || fullNameTF.text == "" {
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
