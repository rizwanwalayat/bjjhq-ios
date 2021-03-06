

import Foundation
import ObjectMapper
import UIKit
import Buy

typealias SignInCompletionHandler = (_ accessToken: String?, _ error: String?) -> Void

final class SignInViewModel: BaseViewModel {
    
    func signInCustomer(email: String, password: String, completion: @escaping SignInCompletionHandler) {
        
        Client.shared.login(email: email, password: password) { accessToken, error in
            if let accessToken = accessToken {
                DataManager.shared.saveUserAccessToken(value: accessToken)
                Client.shared.fetchCustomer(accessToken: accessToken) { customer in
                    if let customer = customer {
                        Global.shared.userModel = customer
                        let id = customer.id
                        let customerID = id.fromBase64()
                        guard let array = customerID?.split(separator: "/") else {return}
                        let finalID:String = String(array.last ?? "")
                        self.signInUserToLocalServer(email: email, password: password, id: finalID) { data, error in
                            if error != nil {
                                completion(nil, nil)
                            }
                            else {
                                if let data = Mapper<UserDataModel>().map(JSON: data as! [String : Any]) {
                                        let convretedData = data.toJSONString()
                                        DataManager.shared.setUser(user: convretedData ?? "")
                                }
                                completion(accessToken, nil)
                            }
                        }
                    }
                    else {
                        completion(nil, error)
                    }
                }
                
            } else {
               completion(nil, error)
            }
        }
    }
    func updateCustomer(email:String,userName:String,bio: String,firstName:String,lastName: String, completion: @escaping SignInCompletionHandler) {
        if DataManager.shared.getUserAccessToekn() != nil {
        Client.shared.updateUser(accessToken: DataManager.shared.getUserAccessToekn()!, firstName: firstName, lastName: lastName, email: email) { responceOfSuccess, responceOfFailure in
            APIClient.shared.updateUser(firstName: firstName, lastName: lastName, bio: bio, username: userName) { headerData, responce,error,status,message  in
                if error != nil {
                    completion(nil, nil)
                }
                else {
                    if let data = Mapper<UserDataModel>().map(JSON: responce as! [String : Any]) {
                            let convretedData = data.toJSONString()
                            DataManager.shared.setUser(user: convretedData ?? "")
                            completion(DataManager.shared.getUserAccessToekn()!, nil)
                        
                    }
                }
            }
        }
            
        }
    }

    
    func guestUser( _ completionHandler: @escaping (_ success: Bool) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        APIClient.shared.guestUser(uuid: uuid) { responce,result, error, statusCode, messsage in

                if let data = Mapper<UserDataModel>().map(JSON: result as! [String : Any]) {
                        let convretedData = data.toJSONString()
                        DataManager.shared.setUser(user: convretedData ?? "")
                    completionHandler(true)
                    
                } else {
                    
                    completionHandler(false)
                }
            }
        }
    
    func updateUserImage(image : [String : Any],_ completionHandler: @escaping (_ success: Bool) -> Void) {
        APIClient.shared.updateImage(params: image) { responce,result, error, statusCode, messsage in
                if let _ = result {
                        completionHandler(true)
                    } else {
                        
                        completionHandler(false)
                    }
                }
            }
    
    func notificationSetting(_ completionHandler: @escaping (_ dataForNotification: NotificationModel?) -> Void) {
        APIClient.shared.fetchNotificationSetting { responce,result, error, statusCode, messsage in
            
                if let responseeeee = result {
                    if let data = Mapper<NotificationModel>().map(JSON: responseeeee as! [String : Any]) {
                        Global.shared.notificationSetting = data
                        if data.notificationSetting?.daily_deal_reminder_time == 2 {
                            Global.shared.selectedIndex = 0
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 4 {
                            Global.shared.selectedIndex = 1
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 6 {
                            Global.shared.selectedIndex = 2
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 8 {
                            Global.shared.selectedIndex = 3
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 10 {
                            Global.shared.selectedIndex = 4
                        }
                        else {
                            Global.shared.selectedIndex = 5
                        }
                        
                        DataManager.shared.setNotification(notifications: data.toJSONString() ?? "")
                        completionHandler(data)
                        
                    } else {
                        
                        completionHandler(nil)
                    }
                }
                else {
                    
                    completionHandler(nil)
                }
        }
        
    }
    
    func notificationSettingUpdate(comments:Bool?,dailyDealNotification:Bool?, dailyDealReminder:Int?,rollingDealNotification:Bool?,rollingDealReminder:Int?,snoozeAlert:Bool?,_ completionHandler: @escaping (_ dataForNotification: NotificationModel?) -> Void) {
        
        APIClient.shared.postNotificationSetting(comments: comments, dailyDealNotification: dailyDealNotification, dailyDealReminder: dailyDealReminder, rollingDealNotification: rollingDealNotification, rollingDealReminder: rollingDealReminder, snoozeAlert: snoozeAlert) { responce,result, error, statusCode, messsage in
            
                if let responseeee = result {
                    if let data = Mapper<NotificationModel>().map(JSON: responseeee as! [String : Any]) {
                        Global.shared.notificationSetting = data
                        DataManager.shared.setNotification(notifications: data.toJSONString() ?? "")
                        if data.notificationSetting?.daily_deal_reminder_time == 2 {
                            Global.shared.selectedIndex = 0
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 4 {
                            Global.shared.selectedIndex = 1
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 6 {
                            Global.shared.selectedIndex = 2
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 8 {
                            Global.shared.selectedIndex = 3
                        }
                        else if data.notificationSetting?.daily_deal_reminder_time == 10 {
                            Global.shared.selectedIndex = 4
                        }
                        else {
                            Global.shared.selectedIndex = 5
                        }
                        completionHandler(data)
                        
                    } else {
                        
                        completionHandler(nil)
                    }
                }
                else {
                    
                    completionHandler(nil)
                }
        }
        
    }
    
    func signInUserToLocalServer(email: String, password: String, id : String,  completion: @escaping (_ result: Any?,_ error: NSError?) -> Void ) {
                
        APIClient.shared.SignIn(email: email, password: password, id: id) { responce,result, error, statusCode, messsage in
                if (error != nil) {
                    print("Header fetching error")
                        } else {
                            let headers = responce?.allHeaderFields
                            guard let token = headers?[AnyHashable("Authorization")] as? String
                            else {
                                return
                            }
//                            let newToken = token.split(separator: " ")
//                            let tokenString:String = String(newToken.last!)
                            DataManager.shared.setLocalToken(value: token)
                            
                        }
                if let responseOfBody = result {
                    completion(responseOfBody, nil)
                }
                else {
                    
                    completion(nil, error)
                }
            }

        }
}


extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
