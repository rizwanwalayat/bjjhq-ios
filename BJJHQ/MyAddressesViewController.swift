//
//  MyAddressesViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import Buy
//import Pay

class MyAddressesViewController: BaseViewController , addressAction {
    
    
    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    var address : [Storefront.MailingAddressEdge]?
    //MARK: - Variables
    
    var selectedAddressIndex = 0
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.setNotificationSwitch(value: [Global.shared.notifications,
                                                         Global.shared.salaat,
                                                         Global.shared.tasbeeh,
                                                         Global.shared.goal])
        Client.shared.fetchAddress { responce,defaultAddress in
            self.address = responce
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - IBAction
    
    @IBAction func backAction(_ sender: Any) {
        coordinator?.popVc()
    }
    
    @IBAction func addNewAddress(_ sender: Any) {
        let vc = AddressBookPopUpViewController(nibName: "AddressBookPopUpViewController", bundle: nil)
        vc.isfromAddNewAddress = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
    //MARK: - Functions
    
    func selectedAddress(index: Int) {
        print("Address selected \(index)")
        self.selectedAddressIndex = index
        tableView.reloadData()
    }
    
    func editAddress(index: Int) {
        print("Edit address \(index)")
        let vc = AddressBookPopUpViewController(nibName: "AddressBookPopUpViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
 

}
extension MyAddressesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.address?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(AddressTableViewCell.self, indexPath: indexPath)
        if indexPath.row == selectedAddressIndex {
            cell.radioButton.isSelected = true
            cell.mainView.borderColor = UIColor(named: "sky")
        }
        else {
            cell.radioButton.isSelected = false
            cell.mainView.borderColor = UIColor(hexString: "#C2C2C2")
        }
        cell.addressLabel.text = self.address?[indexPath.row].node.address1
        cell.delegate = self
        cell.editButton.tag = indexPath.row
        cell.radioButton.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedAddressIndex = indexPath.row
        
        tableView.reloadData()
    }
    
}


