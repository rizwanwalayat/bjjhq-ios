//
//  NotificationViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationViewController: BaseViewController, notificatioSwitch {

    
    
    @IBOutlet weak var tableView: UITableView!
    var array2 = [2,4,6,8,10,12]
    var selectedIndex = Global.shared.selectedIndex
    var notificationData : NotificationModel?
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.shared.notificationSetting == nil {
            self.view.activityStartAnimating()
            SignInViewModel().notificationSetting { data in
                self.view.activityStopAnimating()
                if data != nil {
                    self.notificationData = data
                    self.setupData(data: data)
                }
            }
        }
        else {
            self.notificationData = Global.shared.notificationSetting
            self.setupData(data: Global.shared.notificationSetting)
        }
    }
    
    func setupData(data:NotificationModel?) {
        DispatchQueue.main.async {
            
            if data?.notificationSetting?.daily_deal_reminder_time == 2 {
                Global.shared.selectedIndex = 0
                globalCollectionViewCell?.selectedIndex = 0
            }
            else if data?.notificationSetting?.daily_deal_reminder_time == 4 {
                Global.shared.selectedIndex = 1
                globalCollectionViewCell?.selectedIndex = 1
            }
            else if data?.notificationSetting?.daily_deal_reminder_time == 6 {
                Global.shared.selectedIndex = 2
                globalCollectionViewCell?.selectedIndex = 2
            }
            else if data?.notificationSetting?.daily_deal_reminder_time == 8 {
                Global.shared.selectedIndex = 3
                globalCollectionViewCell?.selectedIndex = 3
            }
            else if data?.notificationSetting?.daily_deal_reminder_time == 10 {
                Global.shared.selectedIndex = 4
                globalCollectionViewCell?.selectedIndex = 4
            }
            else {
                Global.shared.selectedIndex = 5
                globalCollectionViewCell?.selectedIndex = 5
            }
            Global.shared.notificationSetting = data
            DataManager.shared.setNotification(notifications: data?.toJSONString() ?? "")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                globalCollectionViewCell?.collectionView.reloadData()
                print(Global.shared.notificationSetting as Any)
            }
        }
        
    }
    @IBAction func backAction(_ sender: Any) {
        coordinator?.popVc()
    }
    
    func switchState(state: Bool, index: Int) {
        
        print(state,index)
        
        if index == 0 {
            //comment_notifications
            SignInViewModel().notificationSettingUpdate(comments: Global.shared.notificationSetting?.notificationSetting?.comment_notifications, dailyDealNotification: state, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: Global.shared.notificationSetting?.notificationSetting?.snooze_alert) { success in
                if success != nil {
                        self.setupData(data: success)
                    
                }
            }
        }
        else if index == 1 {
            //daily_deal_notifications
            SignInViewModel().notificationSettingUpdate(comments: Global.shared.notificationSetting?.notificationSetting?.comment_notifications, dailyDealNotification: Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: state, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: Global.shared.notificationSetting?.notificationSetting?.snooze_alert) { success in
                if success != nil {
                    self.setupData(data: success)
                }
                
            }
        }
        else if index == 2 {
            //rolling_deal_notifications
            SignInViewModel().notificationSettingUpdate(comments: Global.shared.notificationSetting?.notificationSetting?.comment_notifications, dailyDealNotification: Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: state) { success in
                if success != nil {
                    self.setupData(data: success)
                }
            }
        }
        else {
            //snooze_alert
            SignInViewModel().notificationSettingUpdate(comments: state, dailyDealNotification: Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: Global.shared.notificationSetting?.notificationSetting?.snooze_alert) { success in
                if success != nil {
                    self.setupData(data: success)
                }
            }
        }
        
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
        cell.notificationModel = self.notificationData
        cell.config(index: indexPath.row, data: notificationData)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
