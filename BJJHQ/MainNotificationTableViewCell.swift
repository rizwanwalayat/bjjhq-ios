//
//  MainNotificationTableViewCell.swift
//  BJJHQ
//
//  Created by HaiDer's Macbook Pro on 17/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import UIKit
import ObjectMapper

protocol notificatioSwitch {
    func switchState(state:Bool,index:Int)
}

class MainNotificationTableViewCell: UITableViewCell {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var extraText: UILabel!
    
    
    //MARK: - Variables
    
    var selectedIndex = 7
    var array2 = [2,4,6,8,10,12]
    var notificationModel : NotificationModel?
    var delegagte : notificatioSwitch?
    var array = ["Daily Deals Notifications","Rolling Deals Notifications","Snooze Alert","Comments Notifications"]
    var detailArray = ["Basic alert for our standard 24-hour deals (published daily at 11pm EST)","Turn OFF if you want to pause notifications during our rapid-fire Rolling Deals events","Turn ON if you want alerts when other HQ users interact with your posts on the wall.","Time zone issues? Hitting the hay before 11pm? 'Snooze' provides options for delayed alerts, so you get a reminder when you want 'em."]
    
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    
    //MARK: - IBAction
    
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        self.delegagte?.switchState(state:  sender.isOn, index: sender.tag)
    }
    
    
    
    //MARK: - Functions
    
    func config(index:Int,data:NotificationModel?) {
        self.titleLbl.text = array[index]
        self.detailText.text = detailArray[index]
        if index == 0 {
            collectionView.isHidden = false
            self.stackViewHeight.constant = 50
            self.bottomHeight.constant = 20
        }
        else {
            collectionView.isHidden = true
            self.stackViewHeight.constant = 0
            self.bottomHeight.constant = -20
            self.extraText.text = ""
        }
        if index == 0 {
            self.switchButton.isOn = DataManager.shared.getNotification()?.notificationSetting?.dailyDealNotifications ?? false
            if self.switchButton.isOn  {
                for (i,index) in array2.enumerated() {
                    guard let time = DataManager.shared.getNotification()?.notificationSetting?.daily_deal_reminder_time else {return}
                    if time == index {
                        self.selectedIndex = i
                        collectionView.reloadData()
                        break
                    }
                }
                self.collectionView.alpha = 1
                self.collectionView.isUserInteractionEnabled = true
            }
            else {
                self.collectionView.backgroundColor = .clear
                self.selectedIndex = -1
                self.collectionView.alpha = 0.5
                self.collectionView.isUserInteractionEnabled = false
                
                collectionView.reloadData()
            }
        }
        else if index == 1 {
            self.switchButton.isOn = DataManager.shared.getNotification()?.notificationSetting?.rolling_deal_notifications ?? false
        }
        else if index == 2 {
            self.switchButton.isOn = DataManager.shared.getNotification()?.notificationSetting?.snooze_alert ?? false
        }
        else if index == 3 {
            self.switchButton.isOn = DataManager.shared.getNotification()?.notificationSetting?.comment_notifications ?? false
        }
        
        findingAndReplacing(index: index)
        
    }
    
    func findingAndReplacing(index:Int) {
        
        if self.switchButton.isOn {
            switchButton.onTintColor = UIColor(named: "sky")
        }
        else {
            switchButton.onTintColor = UIColor(named: "blue")
        }
    }
    
}

extension MainNotificationTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.register(NotificationHoursCollectionViewCell.self, indexPath: indexPath)
        cell.config(index:indexPath.row)
        if selectedIndex == indexPath.row {
            cell.mainView.backgroundColor = UIColor(named: "sky")
            cell.mainView.borderColor = .clear
            cell.titleLbl.textColor = .black
        }
        else {
            cell.mainView.backgroundColor = .white
            cell.mainView.borderColor = UIColor(named: "lightGrey")
            cell.titleLbl.textColor = UIColor(named: "lightGrey")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/6), height: 42)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        
        SignInViewModel().notificationSettingUpdate(comments: Global.shared.notificationSetting?.notificationSetting?.comment_notifications, dailyDealNotification: Global.shared.notificationSetting?.notificationSetting?.dailyDealNotifications, dailyDealReminder: self.array2[selectedIndex], rollingDealNotification: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_notifications, rollingDealReminder: Global.shared.notificationSetting?.notificationSetting?.rolling_deal_reminder_time, snoozeAlert: Global.shared.notificationSetting?.notificationSetting?.snooze_alert) { success in
            if success != nil {
                Global.shared.notificationSetting = success
                
                DataManager.shared.setNotification(notifications: success?.toJSONString() ?? "")
            }
        }
        collectionView.reloadData()
    }
}
