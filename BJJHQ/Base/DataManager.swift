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
    
    
    //MARK: - Apple Sign In Data
    func setAppleUser(idToken: String, nameComponents: PersonNameComponents, email: String) {
        
        var dataForAppleSignIn = SocialUser()
        dataForAppleSignIn.idToken = idToken
        dataForAppleSignIn.firstName = "\(nameComponents.namePrefix ?? "") \(nameComponents.givenName ?? "")"
        dataForAppleSignIn.lastName = "\(nameComponents.middleName ?? "") \(nameComponents.familyName ?? "") \(nameComponents.nameSuffix ?? "")"
        dataForAppleSignIn.email = email
        let dataDictionaryForAppleSignIn = dataForAppleSignIn.dictionary
        UserDefaults.standard.set(dataDictionaryForAppleSignIn, forKey: UserDefaultKeys.appleSignInUser)
    }
    func getAppleUser() -> SocialUser? {
        var user: SocialUser?
        if let data = UserDefaults.standard.dictionary(forKey: UserDefaultKeys.appleSignInUser) {
            if let dataDict = data as? [String: String] {
                user = getUserFrom(dictionary: dataDict)
            }
        }
        return user
    }
    func setFacebookUser(idToken: String, firstName: String, lastName: String, email: String) {
        
        var dataForFacebookSignIn = SocialUser()
        dataForFacebookSignIn.idToken = idToken
        dataForFacebookSignIn.firstName = firstName
        dataForFacebookSignIn.lastName = lastName
        dataForFacebookSignIn.email = email
        let dataDictionaryForFacebookSignIn = dataForFacebookSignIn.dictionary
        UserDefaults.standard.set(dataDictionaryForFacebookSignIn, forKey: UserDefaultKeys.facebookSignInUser)
    }
    func getFacebookUser() -> SocialUser? {
        var user: SocialUser?
        if let data = UserDefaults.standard.dictionary(forKey: UserDefaultKeys.facebookSignInUser) {
            if let dataDict = data as? [String: String] {
                user = getUserFrom(dictionary: dataDict)
            }
        }
        return user
    }
    private func getUserFrom(dictionary: [String: String?]) -> SocialUser {
        
        let idToken = dictionary["idToken"] as? String
        let firstName = dictionary["firstName"] as? String
        let lastName = dictionary["lastName"] as? String
        let email = dictionary["email"] as? String
       
        var appleUser = SocialUser()
        appleUser.idToken = idToken ?? ""
        appleUser.firstName = firstName ?? ""
        appleUser.lastName = lastName ?? ""
        appleUser.email = email ?? ""
        
        return appleUser
    }
}
