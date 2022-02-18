//
//  SideMenuViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class SideMenuViewController: BaseViewController, SlideMenuControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backAction(_ sender: Any) {
        let side = slideMenuController()
        side?.closeRight()
    }
    @IBAction func editProfile(_ sender: Any) {
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
            coordinator?.orderPage()
        case 2:
            coordinator?.addressPage()
        case 3:
            print("Contact us")
        case 4:
            coordinator?.notificationPage()
        case 5:
            print("Faq")
        default :
            print("Default")
        }
    }
    
}


