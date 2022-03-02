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
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.clipsToBounds = true
        if let user = DataManager.shared.getUser() {
            
            self.firstNameLastNameLBL.text = String(user.first_name + user.last_name)
            self.userNameLBL.text = user.user_name
        }
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
        vc.isFromSignOut = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(SideMenuTableViewCell.self, indexPath: indexPath)
        cell.config(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
            coordinator?.FAQPage()
        default :
            print("Default")
        }
    }
    
}


