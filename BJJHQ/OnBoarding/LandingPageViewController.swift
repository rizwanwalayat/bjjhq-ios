//
//  LandingPageViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 14/02/2022.
//

import UIKit
import ObjectMapper
import FBSDKLoginKit
struct fbData {
    var id : Int?
    var firstName : String?
    var lastName : String?
    var userName : String?
    var email : String?
    var pictureUrl : Any?
}
class LandingPageViewController: BaseViewController, LoginButtonDelegate {
    

    
    var dataForUser = fbData()
    @IBOutlet weak var skipButton: UIButton!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        let loginButton = FBLoginButton()
//        loginButton.delegate = self
//
//        loginButton.center = view.center
//        loginButton.permissions = ["public_profile", "email"]
//        view.addSubview(loginButton)
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
    
    @IBAction func facebookAction(_ sender: UIButton) {
        if let token = AccessToken.current,
           !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, first_name,last_name,short_name ,picture"], tokenString: token, version: nil, httpMethod: .get)
            request.start { connection, result, error in
                if let r = result as? [String:Any] {
                    var fbData = fbData()
                    fbData.email = r["email"] as? String
                    fbData.id = r["id"] as? Int
                    fbData.userName = r["short_name"] as? String
                    fbData.firstName = r["first_name"] as? String
                    fbData.lastName  = r["last_name"] as? String
                    let picture = r["picture"] as! [String:Any]
                    let pictureData = picture["data"] as! [String:Any]
                    fbData.pictureUrl = pictureData["url"] as? String
                    self.dataForUser = fbData
                    Global.shared.dataForFaceBookUser = fbData
                }
                
            }
        }
        else {
            self.showToast(message: "Facebook not setup yet")
        }
        
    }
    
    @IBAction func skipAction(_ sender: Any) {
        
        self.view.activityStartAnimating()
        self.guestUser { success in
            
            self.view.activityStopAnimating()
            if success {
                self.coordinator?.homePage()
            }
        }
    }
    
    
    func guestUser(_ completionHandler: @escaping(_ success: Bool) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        APIClient.shared.guestUser(uuid: uuid) { responce,result, error, statusCode, messsage in
            if let response = result {
                
                if let data = Mapper<UserDataModel>().map(JSONObject: response) {
                    let convretedData = data.toJSONString()
                    DataManager.shared.setUser(user: convretedData ?? "")
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
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil {
            let token = result?.authenticationToken?.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { connection, result, error in
                if error == nil {
                    if let r = result as? [String:Any] {
                        var fbData = fbData()
                        fbData.email = r["email"] as? String
                        fbData.id = r["id"] as? Int
                        fbData.userName = r["short_name"] as? String
                        fbData.firstName = r["first_name"] as? String
                        fbData.lastName  = r["last_name"] as? String
                        let picture = r["picture"] as! [String:Any]
                        let pictureData = picture["data"] as! [String:Any]
                        fbData.pictureUrl = pictureData["url"] as? String
                        self.dataForUser = fbData
                        Global.shared.dataForFaceBookUser = fbData
                    }
 
                }
                else {
                    self.showToast(message: "Facebook authentication failed")
                }
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        self.showToast(message: "Logged out")
    }
    
}
