//
//  DataManager.swift
//  Vocab
//
//  Created by HaiDer's Macbook Pro on 26/12/2021.
//

import Foundation
import UIKit

class DataManager {
    
    static let shared = DataManager()
    
    

    
    //MARK: - UserState
    
    
    func setNotificationSwitch(value: [Bool]?) {
        UserDefaults.standard.set(value, forKey: "NotificationSwitch")
    }
    
    func getNotificationSwitch() -> [Any]? {
        return UserDefaults.standard.array(forKey: "NotificationSwitch")
    }
    
    
    //MARK: - Access Token  -
    
    func saveUserAccessToken(value: String) {
        UserDefaults.standard.set(value, forKey: "userAccessToken")
    }
    
    func getUserAccessToekn() -> String? {
        return UserDefaults.standard.string(forKey: "userAccessToken") ?? nil
    }
    
    func removeUserAccessToken() {
        UserDefaults.standard.removeObject(forKey: "userAccessToken")
    }
}
