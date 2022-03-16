//
//  Global.swift
//  Vocab
//
//  Created by HaiDer's Macbook Pro on 26/12/2021.
//

import Foundation
import UIKit

class Global {
    
    class var shared : Global {
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    
    var shareString = "BJJHQ"
    var shareUrl = "Link for the app"
    
    //MARK: - Notifications
    var tasbeeh = true
    var salaat = true
    var goal = true
    var notifications = true
    var userModel : CustomerViewModel?
    var FCMtoken : String?
    var selectedIndex = 10
    var notificationSetting : NotificationModel?
    var dataForFaceBookUser = fbData()
}
