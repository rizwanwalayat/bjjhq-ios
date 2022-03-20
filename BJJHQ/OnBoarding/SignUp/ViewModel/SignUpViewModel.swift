//
//  CartItemViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import ObjectMapper
import UIKit
import Buy

typealias SignUpCompletionHandler = (_ data: Storefront.Customer?, _ error: String?) -> Void

final class SignUpViewModel: BaseViewModel {
    
    
    
    func signUpCustomer(fName: String, lName: String, uName: String, email: String, password: String, cPassword: String,fcmToken:String?,  completion: @escaping (_ result: UserDataModel?,_ error: NSError?) -> Void ) {
                
        APIClient.shared.Signup(firstName: fName, LastName: lName, userName: uName, email: email, password: password, cPassword: cPassword,fcmToken:fcmToken) { responce,result, error, statusCode, messsage in
            
            if let response = result {
                
//                let newResult = ["result" : response]
                if let resultData = Mapper<UserDataModel>().map(JSON: response as! [String : Any]) {
                    
                    completion(resultData, nil)
                    
                } else {
                    
                    completion(nil, nil)
                }
            }
            else {
                
                completion(nil, error)
            }
        }
    }
    
    func guestUser(_ completionHandler: @escaping(_ success: Bool) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        APIClient.shared.guestUser(uuid: uuid) { responce,result, error, statusCode, messsage in
            
            if let response = result {
                if let data = Mapper<UserDataModel>().map(JSON: response as! [String : Any]) {
                    
                        let convretedData = data.toJSONString()
                        DataManager.shared.setUser(user: convretedData ?? "")
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


