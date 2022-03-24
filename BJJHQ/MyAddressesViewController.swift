//
//  MyAddressesViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import Buy
import Pay
var globalMyAddressesViewController : MyAddressesViewController?
class Addresses: NSObject {
    var address1 = ""
    var address2 = ""
    var city = ""
    var zip = ""
    var id = ""
    var district = ""
    var country = ""
    
}
class MyAddressesViewController: BaseViewController , addressAction {
    
    
    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    var address : [Storefront.MailingAddressEdge]?
    var defaultAddress : Storefront.MailingAddress?
    var addressArray : [Addresses]?
    //MARK: - Variables
    
    var selectedAddressIndex = 0
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalMyAddressesViewController = self
        self.view.activityStartAnimating()
//        setup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    func setup() {
        Client.shared.fetchAddress { responce,defaultAddress in
            self.defaultAddress = defaultAddress
            self.address = responce
            self.makingAddresses()
            self.view.activityStopAnimating()
        }
    }
    
    
    func makingAddresses () {
        var array = [Addresses]()
        guard let addresssss = self.address else {
            return
        }

        for (i,Addres) in addresssss.enumerated() {
            let Address = Addresses()
            Address.address1  = Addres.node.address1 ?? ""
            Address.address2 = Addres.node.address2 ?? ""
            Address.city = Addres.node.city ?? ""
            Address.zip = Addres.node.zip ?? ""
            Address.country = Addres.node.country ?? ""
            Address.district = Addres.node.province ?? ""
            Address.id = Addres.node.id.rawValue
            if self.defaultAddress?.id == Addres.node.id {
                self.selectedAddressIndex = i
            }
            array.append(Address)
        }
        self.addressArray = array
        self.tableView.reloadData()
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
        self.view.activityStartAnimating()
        Client.shared.updateDefaultAddress(accessToken: DataManager.shared.getUserAccessToekn()!, addressID: addressArray?[index].id ?? "") { responce,defaultAddress in
            self.defaultAddress = defaultAddress
            self.address = responce?.edges
            self.makingAddresses()
            self.view.activityStopAnimating()
        }
        
    }
    
    func editAddress(index: Int) {
        print("Edit address \(index)")
        let vc = AddressBookPopUpViewController(nibName: "AddressBookPopUpViewController", bundle: nil)
        vc.getAddress = self.addressArray?[index]
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
 

}
extension MyAddressesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressArray?.count ?? 0
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
        cell.addressLabel.text = self.addressArray?[indexPath.row].address1
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


