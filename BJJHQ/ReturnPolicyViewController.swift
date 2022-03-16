//
//  ReturnPolicyViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 16/03/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class ReturnPolicyViewController: BaseViewController {

    
    //MARK: - IBOutlets

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - IBAction
    
    
    @IBAction func backAction(_ sender: Any) {
        coordinator?.popVc()
    }
    
}
extension ReturnPolicyViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(ReturnPolicyTableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


