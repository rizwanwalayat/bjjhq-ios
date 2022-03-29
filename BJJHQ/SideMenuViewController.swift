//
//  SideMenuViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class SideMenuViewController: BaseViewController, SlideMenuControllerDelegate {

    @IBOutlet weak var firstNameLastNameLBL: UILabel!
    @IBOutlet weak var userNameLBL: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    var isguestUser = false
    var array = ["Change Password","My Orders","Address Book","Contact Us","Notifications","Shipping & Returns","FAQs"]
    var array2 = ["Contact Us","Return Policy","FAQs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string:  DataManager.shared.getUser()?.avatar ?? "") {
            self.setImage(imageView: self.profileImage, url: url)
            if self.profileImage != nil {
                DataManager.shared.saveProfilePic(value: self.profileImage.image?.pngData())
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setup()
        guard let image = UIImage(data: DataManager.shared.getProfilePic() ?? Data()) else {return}
        self.profileImage.image =  image
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        let side = slideMenuController()
        side?.closeRight()
    }
    @IBAction func editProfile(_ sender: Any) {
        
        coordinator?.profilePage()
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        let vc = DeletePopUpViewController(nibName: "DeletePopUpViewController", bundle: nil)
        vc.coordinator = self.coordinator
        if isguestUser {
            vc.isFromSignIn = true
        }
        else {
            vc.isFromSignOut = true
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    func setup() {
        if let userRole = DataManager.shared.getUser()?.user?.role {
            if userRole == "guest" {
                defer {
                    self.signOutButton.setTitle("Sign In", for: .normal)
                    self.tableView.reloadData()
                }
                self.isguestUser = true
            }
        }
        
        self.profileImage.clipsToBounds = true
        if let user = DataManager.shared.getUser() {
            self.firstNameLastNameLBL.text = "\(user.user?.first_name ?? "") \(user.user?.last_name ?? "")"
            self.userNameLBL.text = user.user?.user_name ?? ""
        }
    }
    
}
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isguestUser {
            return self.array2.count
        }
        else {
            return self.array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(SideMenuTableViewCell.self, indexPath: indexPath)
        if isguestUser {
            cell.config(index: indexPath.row, array: self.array2)
        }
        else {
            cell.config(index: indexPath.row, array: self.array)
        }
       
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.isguestUser {
            switch indexPath.row {
                case 0:
                    coordinator?.contactUsPage()
                case 1:
                    coordinator?.ReturnPolicyPage()
                case 2:
                    coordinator?.FAQPage()
                default :
                    print("Default")
                }
        }
        else {
            switch indexPath.row {
            case 0:
                coordinator?.changePasswordPage()
            case 1:
                coordinator?.myOrdersPage()
            case 2:
                coordinator?.addressPage()
            case 3:
                coordinator?.contactUsPage()
            case 4:
                coordinator?.notificationPage()
            case 5:
                coordinator?.ReturnPolicyPage()
            case 6:
                coordinator?.FAQPage()
            default :
                print("Default")
            }
        }
    
    }
    
}


