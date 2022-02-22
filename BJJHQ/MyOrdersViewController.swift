//
//  MyAddressesViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class MyOrdersViewController: BaseViewController , myOrdersAction {
    
    
    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var selectedAddressIndex = 0
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.setNotificationSwitch(value: [Global.shared.notifications,
                                                         Global.shared.salaat,
                                                         Global.shared.tasbeeh,
                                                         Global.shared.goal])
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
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
extension MyOrdersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(MyOrdersTableViewCell.self, indexPath: indexPath)
      
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedAddressIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


