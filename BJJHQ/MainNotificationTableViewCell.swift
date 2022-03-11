//
//  MainNotificationTableViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

protocol notificatioSwitch {
    func switchState(state:Bool,index:Int)
}

class MainNotificationTableViewCell: UITableViewCell {
    
    
    //MARK: - IBOutlets

    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var titleLbl: UILabel!
    
    var delegagte : notificatioSwitch?
    var array = ["Daily Deals Notifications","Rolling Deals Notifications","Comments Notifications","Reminders"]
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    //MARK: - IBAction
    
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        self.delegagte?.switchState(state:  sender.isOn, index: sender.tag)
    }
    
    
    
    //MARK: - Functions
    
    func config(index:Int) {
        if index == 0 {
            self.switchButton.isOn = Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications ?? false
        }
        else if index == 1 {
            self.switchButton.isOn = Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications ?? false
        }
        else if index == 2 {
            self.switchButton.isOn = Global.shared.notificationSetting?.notificationSetting?.comment_notifications ?? false
        }
        else if index == 3 {
            self.switchButton.isOn = Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time ?? false
        }
        self.titleLbl.text = array[index]
        findingAndReplacing(index: index)
        
    }
    
    func findingAndReplacing(index:Int) {

        guard let arrayForSwitch = DataManager.shared.getNotificationSwitch() as? [Bool] else {return}
        self.switchButton.isOn = arrayForSwitch[index]
        if self.switchButton.isOn {
            switchButton.onTintColor = UIColor(named: "sky")
        }
        else {
            switchButton.onTintColor = UIColor(named: "blue")
        }
    }
    
}
