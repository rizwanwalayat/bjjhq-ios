//
//  NotificationViewController.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController, notificatioSwitch {

    
    
    @IBOutlet weak var tableView: UITableView!
    var array2 = [2,4,6,8,10,12]
    var selectedIndex = Global.shared.selectedIndex
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Global.shared.notificationSetting == nil {
            self.view.activityStartAnimating()
            SignInViewModel().notificationSetting { success in
                self.tableView.reloadData()
                globalCollectionViewCell?.selectedIndex = Global.shared.selectedIndex
                globalCollectionViewCell?.collectionView.reloadData()
                self.view.activityStopAnimating()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func backAction(_ sender: Any) {
        coordinator?.popVc()
    }
    
    func switchState(state: Bool, index: Int) {
        print(state,index)
        if index == 0 {
            //comment_notifications
            SignInViewModel().notificationSettingUpdate(comments: Global.shared.notificationSetting?.notificationSetting?.comment_notifications, dailyDealNotification: state, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: Global.shared.notificationSetting?.notificationSetting?.snooze_alert) { success in
                self.tableView.reloadData()
            }
        }
        else if index == 1 {
            //daily_deal_notifications
            SignInViewModel().notificationSettingUpdate(comments: Global.shared.notificationSetting?.notificationSetting?.comment_notifications, dailyDealNotification: Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: state, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: Global.shared.notificationSetting?.notificationSetting?.snooze_alert) { success in
                self.tableView.reloadData()
            }
        }
        else if index == 2 {
            //rolling_deal_notifications
            SignInViewModel().notificationSettingUpdate(comments: Global.shared.notificationSetting?.notificationSetting?.comment_notifications, dailyDealNotification: Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: state) { success in
                self.tableView.reloadData()
            }
        }
        else {
            //snooze_alert
            SignInViewModel().notificationSettingUpdate(comments: state, dailyDealNotification: Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications, dailyDealReminder: Global.shared.notificationSetting?.notificationSetting?.daily_deal_reminder_time, rollingDealNotification: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: Global.shared.notificationSetting?.notificationSetting?.snooze_alert) { success in
                self.tableView.reloadData()
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
        cell.config(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
