

import Foundation
import ObjectMapper
import UIKit
import Buy

typealias SignInCompletionHandler = (_ accessToken: String?, _ error: String?) -> Void

final class SignInViewModel: BaseViewModel {
    
    func signInCustomer(email: String, password: String, completion: @escaping SignInCompletionHandler) {
        
        Client.shared.login(email: email, password: password) { accessToken, error in
            if let accessToken = accessToken {
                
    //                self.showOrders(animated: true)
                
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
                                    if let user = data.user {
                                        let convretedData = user.toJSONString()
                                        DataManager.shared.setUser(user: convretedData ?? "")
                                    }
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
    
    func guestUser( _ completionHandler: @escaping (_ success: Bool) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        APIClient.shared.guestUser(uuid: uuid) { result, error, statusCode, messsage in
            if let response = result {
                
                let newResult = ["result" : response]
                if let _ = Mapper<UserDataModel>().map(JSON: newResult as [String : Any]) {
                    
                    completionHandler(true)
                    
                } else {
                    
                    completionHandler(false)
                }
            }
            else {
                
                completionHandler(false)
            }
        }
        }
    
    func updateUserImage(image : [String : AnyObject],_ completionHandler: @escaping (_ success: Bool) -> Void) {
        APIClient.shared.updateImage(params: image) { result, error, statusCode, messsage in
                if let response = result {
                    
                    let newResult = ["result" : response]
                    if let _ = Mapper<UserDataModel>().map(JSON: newResult as [String : Any]) {
                        
                        completionHandler(true)
                        
                    } else {
                        
                        completionHandler(false)
                    }
                }
                else {
                    
                    completionHandler(false)
                }
            }
    }
    
    func signInUserToLocalServer(email: String, password: String, id : String,  completion: @escaping (_ result: Any?,_ error: NSError?) -> Void ) {
                
        APIClient.shared.SignIn(email: email, password: password, id: id) { result, error, statusCode, messsage in
            
            if let response = result {
                completion(response, nil)
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
