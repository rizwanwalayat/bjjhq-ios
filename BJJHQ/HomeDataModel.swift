/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

*/

import Foundation
import ObjectMapper

class HomeDataModel : Mappable
{
	var response : ProductInfo?
	var message = ""

	required init?(map: Map) {

	}

	func mapping(map: Map) {

		response <- map["response"]
		message <- map["message"]
	}
}

class ProductInfo : Mappable
{
    var current_product_id = Double()
    var time_interval = Int()
    var last_updated_at = ""
    var lastUpdateDate = Date()

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        current_product_id <- map["current_product_id"]
        time_interval <- map["time_interval"]
        last_updated_at <- map["last_updated_at"]
        
        if let date = last_updated_at.stringToDate("yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            lastUpdateDate = date
        }
    }

}
