/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com



*/

import Foundation
import ObjectMapper

struct UserDataModel : Mappable {
    var user : UserData?
	var message = ""
    var avatar : String?
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		user <- map["user"]
		message <- map["message"]
        avatar <- map["avatar"]
	}
}

struct UserData : Mappable {
    var id = -1
    var email = ""
    var created_at = ""
    var updated_at = ""
    var fcm_token = ""
    var first_name = ""
    var last_name = ""
    var user_name = ""
    var shopify_customer_id = ""
    var shopify_authorization_token = ""
    var uuid = ""
    var role = ""
    var bio = ""
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        email <- map["email"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        fcm_token <- map["fcm_token"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        user_name <- map["user_name"]
        shopify_customer_id <- map["shopify_customer_id"]
        shopify_authorization_token <- map["shopify_authorization_token"]
        uuid <- map["uuid"]
        role <- map["role"]
        bio <- map["bio"]
        
        if role == ""
        {
            role = "user"
        }
    }

}

struct NotificationModel : Mappable {
    
    var message = ""
    var notificationSetting : NotificationsSetting?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
        notificationSetting <- map["notification_setting"]
    }
}
struct NotificationsSetting : Mappable {
    var id : Int?
    var dailyDealNotifications : Bool?
    var daily_deal_reminder_time : Bool?
    var rolling_deal_notifications : Bool?
    var rolling_deal_reminder_time : Bool?
    var comment_notifications : Bool?
    var created_at = ""
    var updated_at = ""
    var user_id : Int?
    var snooze_alert : Bool?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        dailyDealNotifications <- map["daily_deal_notifications"]
        daily_deal_reminder_time <- map["daily_deal_reminder_time"]
        rolling_deal_notifications <- map["rolling_deal_notifications"]
        rolling_deal_reminder_time <- map["rolling_deal_reminder_time"]
        comment_notifications <- map["comment_notifications"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        user_id <- map["user_id"]
        snooze_alert <- map["snooze_alert"]
    }
    
}
