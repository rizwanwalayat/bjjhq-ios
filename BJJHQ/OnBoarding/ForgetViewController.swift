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
        setupButtonUnderlineText(signInBUtton, "Try Signing In", color: "#5BD6CD",1.0)
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
        Client.shared.applyForReset(email: self.emailTF.text ?? "") { done in
            
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
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        var enable = false
//        if ((emailTF.text?.isValidEmail()) == false) {
//            self.emailView.backgroundColor = UIColor(hexString: "#7C808F")
//        }
//        else {
//            self.emailView.backgroundColor = UIColor(hexString: "#DF6565")
//        }
//        
//        if ((emailTF.text?.isValidEmail()) == false) {
//            enable = false
//        }
//        else {
//            enable = true
//        }
//        
//        changeButtonState(state: enable)
//    }
    
}
