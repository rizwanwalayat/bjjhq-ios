//
//  Constants.swift
//  Haid3r
//
//  Created by a on 04/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import UIKit


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
    static var updateImage = "users/profiles/update_avatar"
    static var updateProfile = "users/profiles/update_profile"
    static var changePassword = "user/change_password"
    static var comments = "comments"
    static var dislike = "dislike"
    static var like = "like"
    static var reactions = "reactions"
    
}

struct FireBaseVariables {
    static var fireBaseToken = ""
}
