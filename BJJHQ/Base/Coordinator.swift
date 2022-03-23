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
    func landingPage()
    func homePage()
    func signUpPage()
    func signInPage()
    func emailPage()
    func addressPage()
    func orderSuccesfullPopUp()
    func notificationPage()
    func changePasswordPage ()
    func orderPage()
    func profilePage()
    func FAQPage()
    func splashPage()
    func ReturnPolicyPage()
    func myOrderDetail(_ size:Int, _ productID : String,productModel : ProductViewModel?)
    func openWKWebViewControllerFor(_ url: URL, token: String)
    func successController()
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
    func openWKWebViewControllerFor(_ url: URL, token: String) {
        let webController = WebViewController(url: url, accessToken: token)
        navigationController.navigationBar.isHidden = false
        webController.coordinator = self
        navigationController.pushViewController(webController, animated: true)
    }
    
    func landingPage() {
        let vc = LandingPageViewController()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    func myOrderDetail(_ size:Int, _ productID : String,productModel : ProductViewModel?) {
        let vc = OrderViewController()
        vc.coordinator = self
        vc.productId = productID
        vc.productModel = productModel
        vc.size = size
        navigationController.pushViewController(vc, animated: true)
    }
    
    func homePage() {
        let homeController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let leftViewController = SideMenuViewController()
        leftViewController.coordinator = self
        homeController.coordinator = self
        let mainViewController = homeController
        let sideMenuController: SlideMenuController?
        sideMenuController =  SlideMenuController(mainViewController: mainViewController, rightMenuViewController: leftViewController)
        sideMenuController!.delegate = leftViewController
        sideMenuController!.changeRightViewWidth(UIScreen.main.bounds.width)
        sideMenuController!.removeLeftGestures()
        sideMenuController!.removeRightGestures()
        navigationController.setViewControllers([sideMenuController!], animated: true)
    }
    func splashPage() {
        let vc = SplashViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func signUpPage() {
        let vc = SignUpViewController()
        vc.coordinator = self
        vc.viewModel = SignUpViewModel.init()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func emailPage() {
        let vc = EmailUpdateViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func changePasswordPage() {
        let vc = ChangePasswordViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func orderPage() {
        let vc = OrderViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func myOrdersPage() {
        let vc = MyOrdersViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func orderSuccesfullPopUp() {
        let vc = OrderSuccesFullViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func addressPage() {
        let vc = MyAddressesViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func contactUsPage() {
        let vc = ContactUsViewController()
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
        vc.viewModel = SignInViewModel.init()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func notificationPage() {
        let vc = NotificationViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func profilePage() {
        let vc = UserProfileViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func FAQPage() {
        let vc = FaqViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func ReturnPolicyPage() {
        let vc = ReturnPolicyViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func successController() {
        let vc = SuccessViewController()
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
