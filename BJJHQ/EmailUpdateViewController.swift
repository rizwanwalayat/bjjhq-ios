//
//  EmailUpdateViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class EmailUpdateViewController: BaseViewController {

    
    //MARK: - IBOutlets

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var desriptionLbl: UILabel!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonState(state: false)
            self.popUpView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDidappear()
    }
    
    
    //MARK: - IBAction
    
    @IBAction func crossAction(_ sender: Any) {
        hidePopup()
    }
    
    
    
    //MARK: - Functions
    
    func changeButtonState(state:Bool) {
        if state {
            submitButton.backgroundColor = UIColor(hexString: "DF6565")
        }
        else {
            submitButton.backgroundColor = UIColor(hexString: "#E2E3E7")
        }
    }
    
    
    func setupDidappear() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
            self.popUpView.transform = .identity
        })
        
    }
    
    func hidePopup() {
        popUpView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        }) { (success) in
            
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    

}

extension EmailUpdateViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        var enable = false
        if ((emailTF.text?.isValidEmail()) == false) {
            self.emailView.backgroundColor = UIColor(hexString: "#7C808F")
        }
        else {
            self.emailView.backgroundColor = UIColor(hexString: "#DF6565")
        }
        
        if ((emailTF.text?.isValidEmail()) == false) {
            enable = false
        }
        else {
            enable = true
        }
        
        changeButtonState(state: enable)
    }
    
}
