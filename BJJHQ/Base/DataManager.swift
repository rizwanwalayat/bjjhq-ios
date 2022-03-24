//
//  DataManager.swift
//  Vocab
//
//  Created by HaiDer's Macbook Pro on 26/12/2021.
//

import Foundation
import UIKit
import ObjectMapper

class DataManager {
    
    static let shared = DataManager()
    
    
    //MARK: - Access Token
    
    func saveUserAccessToken(value: String) {
        UserDefaults.standard.set(value, forKey: "userAccessToken")
    }
    
    func getUserAccessToekn() -> String? {
        return UserDefaults.standard.string(forKey: "userAccessToken") ?? nil
    }
    
    func saveProfilePic(value: Data?) {
        UserDefaults.standard.set(value, forKey: "profilePic")
    }
    
    func getProfilePic() -> Data? {
        return UserDefaults.standard.data(forKey: "profilePic")
    }
    func removeProfilePic() {
        return UserDefaults.standard.removeObject(forKey: "profilePic")
    }
    
    func setLocalToken(value: String) {
        UserDefaults.standard.set(value, forKey: "token")
    }
    
    func getLocalToken() -> String? {
        return UserDefaults.standard.string(forKey: "token") ?? nil
    }
    
    func removeUserAccessToken() {
        UserDefaults.standard.removeObject(forKey: "userAccessToken")
    }
    func setUser (user: String) {
        UserDefaults.standard.set(user, forKey: "user_data")
    }
    func getUser() -> UserDataModel? {
        var user: UserDataModel?

        if UserDefaults.standard.object(forKey: "user_data") != nil {
            user = Mapper<UserDataModel>().map(JSONString:UserDefaults.standard.string(forKey: "user_data")!)
        }
        return user
    }
    
    func deleteUser () {
         UserDefaults.standard.set(nil, forKey: "user_data")
        
    }
    
    func setNotification(notifications: String) {
        UserDefaults.standard.set(notifications, forKey: "user_Notifications")
    }
    func getNotification() -> NotificationModel? {
        var user: NotificationModel?

        if UserDefaults.standard.object(forKey: "user_Notifications") != nil {
            user = Mapper<NotificationModel>().map(JSONString:UserDefaults.standard.string(forKey: "user_Notifications")!)
        }
        return user
    }
    
    func deleteNotification () {
         UserDefaults.standard.set(nil, forKey: "user_Notifications")
        
    }
}
