//
//  LandingPageViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 14/02/2022.
//

import UIKit
import ObjectMapper
import FBSDKLoginKit
import AuthenticationServices

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
    @IBOutlet weak var signInButtonsStackView: UIStackView!
    @IBOutlet weak var appleSignInButton: AuthorizationAppleIDButton!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let loginButton = FBLoginButton()
        loginButton.delegate = self
//        loginButton.center = view.center
        loginButton.permissions = ["public_profile", "email"]
//        view.addSubview(loginButton)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.removeConstraints(loginButton.constraints)
        loginButton.setImage(UIImage(named: ""), for: .normal)
        loginButton.widthAnchor.constraint(equalToConstant: appleSignInButton.frame.width).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInButtonsStackView.addArrangedSubview(loginButton)
        
//        do {
//             KeychainItem.deleteUserIdentifierFromKeychain()
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print("authorized")
                    break
                case .revoked:
                    print("revoked")
                    break
                case .notFound:
                    print("not found")
                    break
                default:
                    break
                }
            }
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
    
    @IBAction func appleSignInAction(_ sender: AuthorizationAppleIDButton) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        loginButton.setImage(UIImage(named: ""), for: .normal)
        self.showToast(message: "Logged out")
    }
    
}

extension LandingPageViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            self.showAlert(title: "User Data", message: "\(fullName) \(email)")
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: Bundle.main.bundleIdentifier ?? BUNDLE_IDENTIFIER, account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
//    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
//        guard let viewController = self.presentingViewController as? ResultViewController
//            else { return }
//
//        DispatchQueue.main.async {
//            viewController.userIdentifierLabel.text = userIdentifier
//            if let givenName = fullName?.givenName {
//                viewController.givenNameLabel.text = givenName
//            }
//            if let familyName = fullName?.familyName {
//                viewController.familyNameLabel.text = familyName
//            }
//            if let email = email {
//                viewController.emailLabel.text = email
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
extension LandingPageViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
