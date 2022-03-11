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

class MyOrdersViewController: BaseViewController , myOrdersAction {
    
    
    //MARK: - IBOutlets

    @IBOutlet weak var loadMore: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var selectedAddressIndex = 0
    var ordersNumber :Int32 = 5
    var ordersArray : [Storefront.OrderEdge]?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.activityStartAnimating()
        Client.shared.fetchOrders(accessToken: DataManager.shared.getUserAccessToekn()!, orders: self.ordersNumber) { edgess,nextPageInfo in
            self.view.activityStopAnimating()
            self.ordersArray = edgess
            self.tableView.reloadData()
        }
        loadMore.setTitle("", for: .normal)
        setupButtonUnderlineText(loadMore, "Load More", color: "252C44",1)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    
    //MARK: - IBAction
    
    @IBAction func loadMoreAction(_ sender: Any) {
        self.ordersNumber = ordersNumber + 5
        Client.shared.fetchOrders(accessToken: DataManager.shared.getUserAccessToekn()!, orders: self.ordersNumber) { edgess,nextPageInfo in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        coordinator?.popVc()
    }
  
    
    
    //MARK: - Functions


}
extension MyOrdersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ordersArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(MyOrdersTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.config(ordersArray: self.ordersArray, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedAddressIndex = indexPath.row
        let vc = OrderViewController()
        vc.coordinator = self.coordinator
        vc.orderDetail = self.ordersArray?[indexPath.row]
        self.coordinator?.navigationController.pushViewController(vc, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


