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
//        changeButtonState(state: true)
    }
    
    
    //MARK: - IBAction
    
    @IBAction func visibilityAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.passwordTF.isSecureTextEntry = false
            self.confirmPasswordTF.isSecureTextEntry = false
        }
        else {
            self.passwordTF.isSecureTextEntry = true
            self.confirmPasswordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        coordinator?.welcomePage()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        if ((emailTF.text?.isValidEmail()) != nil) {
            if passwordTF.text == confirmPasswordTF.text {
                if passwordTF.text != "" {
                    self.callApi()
                }
                else {
                    self.showToast(message: "Please enter a password")
                }
                
            }
            else {
                self.showToast(message: "Password not matched")
            }
            
        }
        else {
            self.showToast(message: "You have entered an invalid email")
        }

    }
    func callApi() {
        self.view.activityStartAnimating()
        viewModel?.signUpCustomer(fName: firstNameTF.text!, lName: lastNameTF.text!, uName: userNameTF.text!, email: emailTF.text!, password: passwordTF.text!, cPassword: confirmPasswordTF.text!, fcmToken: Global.shared.FCMtoken, completion: { response, error in

            self.view.activityStopAnimating()

            if let result = response, error == nil {
                self.showToast(message: result.message)
                self.coordinator?.signInPage()
            }
            else {

                self.showToast(message: error?.localizedDescription ?? "Something went wrong, please try again later")
            }
        })
    }
    
    @IBAction func signInAction(_ sender: Any) {
        coordinator?.signInPage()
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
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        
        if checkButtonImageView.image == UIImage(named: "checkSignup") {
            checkButtonImageView.image = nil
            checkButtonImageView.superview?.borderWidth = 0.5
            checkButtonImageView.superview?.borderColor = UIColor(hexString: "252C44")
        }
        else {
            checkButtonImageView.image = UIImage(named: "checkSignup")
            checkButtonImageView.superview?.borderWidth = 0
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == firstNameTF {
            self.firstNameView.backgroundColor = UIColor(named: "sky")
            self.lastNameView.backgroundColor = UIColor(named: "lightGrey")
            self.emailView.backgroundColor = UIColor(named: "lightGrey")
            self.userNameview.backgroundColor = UIColor(named: "lightGrey")
            self.passwordView.backgroundColor = UIColor(named: "lightGrey")
            self.confirmPasswordView.backgroundColor = UIColor(named: "lightGrey")
        }
        else if textField == lastNameTF {
            self.firstNameView.backgroundColor = UIColor(named: "lightGrey")
            self.lastNameView.backgroundColor = UIColor(named: "sky")
            self.emailView.backgroundColor = UIColor(named: "lightGrey")
            self.userNameview.backgroundColor = UIColor(named: "lightGrey")
            self.passwordView.backgroundColor = UIColor(named: "lightGrey")
            self.confirmPasswordView.backgroundColor = UIColor(named: "lightGrey")
        }
        else if textField == emailTF {
            self.firstNameView.backgroundColor = UIColor(named: "lightGrey")
            self.lastNameView.backgroundColor = UIColor(named: "lightGrey")
            self.emailView.backgroundColor = UIColor(named: "sky")
            self.userNameview.backgroundColor = UIColor(named: "lightGrey")
            self.passwordView.backgroundColor = UIColor(named: "lightGrey")
            self.confirmPasswordView.backgroundColor = UIColor(named: "lightGrey")
        }
        else if textField == userNameTF {
            self.firstNameView.backgroundColor = UIColor(named: "lightGrey")
            self.lastNameView.backgroundColor = UIColor(named: "lightGrey")
            self.emailView.backgroundColor = UIColor(named: "lightGrey")
            self.userNameview.backgroundColor = UIColor(named: "sky")
            self.passwordView.backgroundColor = UIColor(named: "lightGrey")
            self.confirmPasswordView.backgroundColor = UIColor(named: "lightGrey")
        }
        else if textField == passwordTF {
            self.firstNameView.backgroundColor = UIColor(named: "lightGrey")
            self.lastNameView.backgroundColor = UIColor(named: "lightGrey")
            self.emailView.backgroundColor = UIColor(named: "lightGrey")
            self.userNameview.backgroundColor = UIColor(named: "lightGrey")
            self.passwordView.backgroundColor = UIColor(named: "sky")
            self.confirmPasswordView.backgroundColor = UIColor(named: "lightGrey")
        }
        else {
            self.firstNameView.backgroundColor = UIColor(named: "lightGrey")
            self.lastNameView.backgroundColor = UIColor(named: "lightGrey")
            self.emailView.backgroundColor = UIColor(named: "lightGrey")
            self.userNameview.backgroundColor = UIColor(named: "lightGrey")
            self.passwordView.backgroundColor = UIColor(named: "lightGrey")
            self.confirmPasswordView.backgroundColor = UIColor(named: "sky")
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            self.firstNameView.backgroundColor = UIColor(named: "lightGrey")
            self.lastNameView.backgroundColor = UIColor(named: "lightGrey")
            self.emailView.backgroundColor = UIColor(named: "lightGrey")
            self.userNameview.backgroundColor = UIColor(named: "lightGrey")
            self.passwordView.backgroundColor = UIColor(named: "lightGrey")
            self.confirmPasswordView.backgroundColor = UIColor(named: "lightGrey")
    }
    
}
