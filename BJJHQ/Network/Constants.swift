//
//  Constants.swift
//  Haid3r
//
//  Created by a on 04/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import UIKit


let BUNDLE_IDENTIFIER = "com.shopify.bjjhq"
struct APIRoutes {

    static var baseUrl = "https://bjjhq.phaedrasolutions.com/api/" 
    
    // MARK: End Ponints
    static var signup = "users"
    static var guest = "guests"
    static var logout = "users/sign_out"
    static var current_deal = "current_deal"
    static var signin = "users/sign_in"
    static var contactUS = "contact_us"
    static var NotificationSetting = "users/notification_setting"
    static var reminderHours = "users/notification_setting"
    static var updateNotification = "users/notification_setting"
    static var updateImage = "users/profiles/update_avatar"
    static var updateProfile = "users/profiles/update_profile"
    static var changePassword = "user/change_password"
    static var comments = "comments"
    static var fetchcomments = "get_comments"
    static var dislike = "dislike"
    static var like = "like"
    static var editComment = "edit_comment"
    static var deleteComment = "delete_comment"
    static var emailCheck = "email"
    static var reactions = "reactions"
    static var commentImage = baseUrl + "comments"
    
}

struct FireBaseVariables {
    static var fireBaseToken = ""
}

struct UserDefaultKeys {
    static let appleSignInUser = "appleSignInUser"
    static let facebookSignInUser = "facebookSignInUser"
}
