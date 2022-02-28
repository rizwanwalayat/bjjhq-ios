

import Foundation
import ObjectMapper
import UIKit
import Buy

typealias SignInCompletionHandler = (_ accessToken: String?, _ error: String?) -> Void

final class SignInViewModel: BaseViewModel {
    
    func signInCustomer(email: String, password: String, completion: @escaping SignInCompletionHandler) {
        
        Client.shared.login(email: email, password: password) { accessToken, error in
            if let accessToken = accessToken {
                AccountController.shared.save(accessToken: accessToken)
    //                self.showOrders(animated: true)
                completion(accessToken, nil)
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
}


