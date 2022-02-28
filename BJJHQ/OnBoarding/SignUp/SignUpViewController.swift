//
//  SignUpViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 15/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import Buy


class SignUpViewController: BaseViewController {
    
    var viewModel: SignUpViewModel?
        
    //MARK: - IBOutlets
    
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var userNameview: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var checkButtonImageView: UIImageView!
    @IBOutlet weak var passwordTFStatus: UILabel!
    @IBOutlet weak var comfirmPasswordTFStatus: UILabel!
    
    
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
//        viewModel?.signUpCustomer(email: emailTF.text!, password: passwordTF.text!, firstName: firstNameTF.text!, lastName: lastNameTF.text!) { customer, error in
//            if error != nil {
//                self.showToast(message: error ?? "Error")
//            }
//        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        coordinator?.signInPage()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        coordinator?.homePage()
    }
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        
        if checkButtonImageView.backgroundColor == .clear {
            checkButtonImageView.backgroundColor = UIColor(hexString: "252C44")
        }
        else {
            checkButtonImageView.backgroundColor = .clear
        }
    }
    
    @IBAction func passwordTFChanged(_ sender: Any) {
        
        if passwordTF.text!.count == 0{
            passwordTFStatus.text = ""
        }
        else if passwordTF.text!.count < 8 {
            passwordTFStatus.text = "weak"
            passwordTFStatus.textColor = UIColor(hexString: "#BB0808")
        }
        else if passwordTF.text!.count >= 8 {
            if checkTextSufficientComplexity(text: passwordTF.text!) {
                
                passwordTFStatus.text = "Strong"
                passwordTFStatus.textColor = UIColor(hexString: "#28A938")
            }
            else {
                
                passwordTFStatus.text = "Normal"
                passwordTFStatus.textColor = UIColor(hexString: "#C4C436")
            }
        }
    }
    
    @IBAction func comfirmPasswordChanged(_ sender: Any) {
        
        if confirmPasswordTF.text!.count == 0{
            comfirmPasswordTFStatus.text = ""
        }
        else if confirmPasswordTF.text! == passwordTF.text!
        {
            comfirmPasswordTFStatus.text = "✓ Matched"
            comfirmPasswordTFStatus.textColor = UIColor(hexString: "#28A938")
        }
        else {
            
            comfirmPasswordTFStatus.text = "! Not Matched"
            comfirmPasswordTFStatus.textColor = UIColor(hexString: "#BB0808")
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
    
    func checkTextSufficientComplexity(text : String) -> Bool{


        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print(capitalresult)


        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print(numberresult)


        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)

        let specialresult = texttest2.evaluate(with: text)
        print(numberresult)

        return capitalresult || numberresult || specialresult

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
        
        if confirmPasswordTF.text!.count < 8 {
            self.confirmPasswordView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        
        else {
            self.confirmPasswordView.backgroundColor = UIColor(hexString: "#5BD6CD")
        }
        


        if passwordTF.text == "" || ((emailTF.text?.isValidEmail()) == false) || userNameTF.text == "" || firstNameTF.text == "" || confirmPasswordTF.text == "" {
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
