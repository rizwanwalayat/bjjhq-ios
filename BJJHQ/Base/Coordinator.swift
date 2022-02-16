//
//  Coordinator.swift
//  Vocab
//
//  Created by HaiDer's Macbook Pro on 26/12/2021.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func landedPage()
    func homePage()
    func signUpPage()
    func signInPage()
    func emailPage()
    func orderSuccesfullPopUp()
    
}

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    
    func welcomePage() {
        let vc = LandingPageViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func landedPage() {
        let vc = LandingPageViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func homePage() {
        let vc = HomeViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signUpPage() {
        let vc = SignUpViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func emailPage() {
        let vc = EmailUpdateViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func orderSuccesfullPopUp() {
        let vc = OrderSuccesFullViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func forgetPage() {
        let vc = ForgetViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signInPage() {
        let vc = SignInViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func popVc() {
        navigationController.popViewController(animated: true)
    }
    
}

//MARK: - StoryBoard Reference
extension UIStoryboard {
    
    class func controller  <T: UIViewController> (storyboardName : String = "Home") -> T {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: T.className) as! T
    }
}

//MARK: - NSObject
extension NSObject {
    class var className: String {
        return String(describing: self.self)
    }
}

//extension MainCoordinator: SignUpControllerDelegate {
//    func signUpCustomer(email: String, password: String, firstName: String, lastName: String) {
//        Client.shared.createCustomer(email: email, password: password, firstName: firstName, lastName: lastName) { customerName in
//            print("\(customerName)")
//        }
//    }
//}
