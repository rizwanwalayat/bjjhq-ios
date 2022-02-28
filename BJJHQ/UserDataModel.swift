/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com



*/

import Foundation
import ObjectMapper

struct UserDataModel : Mappable {
    var user : UserData?
	var message = ""

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		user <- map["user"]
		message <- map["message"]
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
    }

}
