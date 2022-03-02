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
}

struct FireBaseVariables {
    static var fireBaseToken = ""
}
