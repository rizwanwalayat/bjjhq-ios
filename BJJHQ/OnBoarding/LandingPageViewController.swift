//
//  LandingPageViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 14/02/2022.
//

import UIKit
import ObjectMapper

class LandingPageViewController: BaseViewController {

    @IBOutlet weak var skipButton: UIButton!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    
    //MARK: - Functions
    
    func setup() {
        skipButton.setTitle("", for: .normal)
        setupButtonUnderlineText(skipButton, "SKIP", color: "BCBFCC")
    }
    
    
    //MARK: - IBAction
    
    
    @IBAction func signInAction(_ sender: Any) {
        coordinator?.signInPage()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        coordinator?.signUpPage()
    }
    
    @IBAction func facebookAction(_ sender: Any) {
        
    }
    
    @IBAction func skipAction(_ sender: Any) {
        
//        self.view.activityStartAnimating()
//        self.guestUser { success in
//
//            self.view.activityStopAnimating()
//            if success {
//                self.coordinator?.homePage()
//            }
//        }
        coordinator?.homePage()
    }
    
    
    func guestUser(_ completionHandler: @escaping(_ success: Bool) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        APIClient.shared.guestUser(uuid: uuid) { result, error, statusCode, messsage in
            if let response = result {
                
                let newResult = ["result" : response]
                if let _ = Mapper<UserDataModel>().map(JSON: newResult as [String : Any]) {
                    
                    completionHandler(true)
                    
                } else {
                    
                    completionHandler(false)
                }
            }
            else {
                
                completionHandler(false)
            }
        }
    }
    
}
