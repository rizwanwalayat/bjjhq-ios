//
//  NotificationViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController, notificatioSwitch {

    
    var arrayForSwitch = DataManager.shared.getNotificationSwitch() as? [Bool]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backAction(_ sender: Any) {
        
    }
    
    func switchState(state: Bool, index: Int) {
        print(state,index)
        guard var arrayForSwitch = DataManager.shared.getNotificationSwitch() as? [Bool] else {return}
        arrayForSwitch[index] = state
        self.arrayForSwitch = arrayForSwitch
        DataManager.shared.setNotificationSwitch(value: arrayForSwitch)
        tableView.reloadData()
    }

}

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(MainNotificationTableViewCell.self, indexPath: indexPath)
        cell.switchButton.tag = indexPath.row
        cell.delegagte = self
        cell.config(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}