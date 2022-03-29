//
//  HomeViewModel.swift
//  BJJHQ
//
//  Created by MAC on 01/03/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Buy


typealias HomeCompletionHandler = (_ accessToken: HomeDataModel?, _ error: String?) -> Void

class HomeViewModel: BaseViewModel {
    
    
    func fetchCurrentDeal(_ completionHandler: @escaping(_ success: Bool, _ data : HomeDataModel?, _ message : String?) -> Void) {
        

        APIClient.shared.fetchCurrentDeal() { responce,result, error, statusCode, messsage in
            
            if let response = result {
                
                if let data = Mapper<HomeDataModel>().map(JSONObject: response ) {
                    
                    completionHandler(true, data, nil)
                    
                } else {
                    
                    completionHandler(false, nil, messsage)
                }
            }
            else {
                
                completionHandler(false, nil, error?.localizedDescription ?? messsage)
            }
        }
    }
    
    func fetchComments(_ completionHandler: @escaping(_ success: Bool, _ data : CommentsDataModel?, _ message : String?) -> Void) {
        

        APIClient.shared.fetchComments() { response, result, error, code, message  in
            
            if let response = result {
                
                if let data = Mapper<CommentsDataModel>().map(JSONObject: response ) {

                    completionHandler(true, data, nil)

                } else {

                    completionHandler(false, nil, message)
                }
            }
            else {
                
                completionHandler(false, nil, error?.localizedDescription ?? message)
            }
        }
    }
    
    func sendComments(_ parentCommentId: String,_ message: String, _ completionHandler: @escaping(_ success: Bool, _ message : String?) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        APIClient.shared.sendComments(mobileId: uuid, userSystemId: "\(userId)", parentCommentId: parentCommentId, message: message, role: role) { responce, result, error, statusCode, messsage in
            
            if let response = result {
                
                if let success = response["status"] as? Bool {
                    
                    completionHandler(success, message)
                }
                else {
                    completionHandler(false,  error?.localizedDescription ?? message)
                }
            }
            else {
                
                completionHandler(false, error?.localizedDescription ?? message)
            }
        }
    }
    
    func sendImageComment(_ parentCommentId: String,_ message: String, image: UIImage, _ completionHandler: @escaping(_ success: Bool, _ message : String?) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        APIClient.shared.sendImageComments(mobileId: uuid, userSystemId: "\(userId)", message: message, role: role, image: image) { responce, result, error, statusCode, messsage in
            
            if let response = result {
                if let success = response["status"] as? Bool {
                    
                    completionHandler(success, message)
                }
                else {
                    completionHandler(false,  error?.localizedDescription ?? message)
                }
            }
            else {
                
                completionHandler(false, error?.localizedDescription ?? message)
            }
        }
    }
    func sendImageEditComment(_ parentCommentId: String,_ message: String, image: UIImage, _ completionHandler: @escaping(_ success: Bool, _ message : String?) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        APIClient.shared.sendImageEditComments(mobileId: uuid, userSystemId: "\(userId)", message: message, role: role, image: image) { responce, result, error, statusCode, messsage in
            
            if let response = result {
                if let success = response["status"] as? Bool {
                    
                    completionHandler(success, message)
                }
                else {
                    completionHandler(false,  error?.localizedDescription ?? message)
                }
            }
            else {
                
                completionHandler(false, error?.localizedDescription ?? message)
            }
        }
    }
    
    func fetchSignleProduct(_ productId: String, _ completion: @escaping(_ data: Storefront.Product?) -> Void )
    {
        Client.shared.fetchSignleProduct(productId: productId) { productData in
            
            if let data = productData {
                completion(data)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func fetchProducts(_ productId: String, _ completion: @escaping(_ data: PageableArray<ProductViewModel>?) -> Void )
    {
        Client.shared.fetchProductsDirectly { productsData in
            
            if let data = productsData {
                completion(data)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func disLikeComment(_ commentId: Int, _ completionHandler: @escaping(_ success: Bool, _ message : String?) -> Void)
    {
        
        APIClient.shared.dislikesComment(commentId) { response, result, error, code, message  in
            
            if let response = result {
                
                if let success = response["status"] as? Bool {
                    
                    completionHandler(success, message)
                }
                else {
                    completionHandler(false,  error?.localizedDescription ?? message)
                }
            }
            else {
                
                completionHandler(false, error?.localizedDescription ?? message)
            }
        }
    }
    func editComments(_ parentCommentId: String,_ message: String, _ completionHandler: @escaping(_ success: Bool, _ message : String?) -> Void) {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        APIClient.shared.editComments(mobileId: uuid, userSystemId: "\(userId)", parentCommentId: parentCommentId, message: message, role: role) { responce, result, error, statusCode, messsage in
            
            if let response = result {
                
                if let success = response["status"] as? Bool {
                    
                    completionHandler(success, message)
                }
                else {
                    completionHandler(false,  error?.localizedDescription ?? message)
                }
            }
            else {
                
                completionHandler(false, error?.localizedDescription ?? message)
            }
        }
    }
    
    func deleteComment(_ commentId: Int, _ completionHandler: @escaping(_ success: Bool, _ message : String?) -> Void)
    {
        
        APIClient.shared.deleteComment(commentId) { response, result, error, code, message  in
            
            if let response = result {
                
                if let success = response["status"] as? Bool {
                    
                    completionHandler(success, message)
                }
                else {
                    completionHandler(false,  error?.localizedDescription ?? message)
                }
            }
            else {
                
                completionHandler(false, error?.localizedDescription ?? message)
            }
        }
    }
    
    func likeComment(_ commentId: Int,_ completionHandler: @escaping(_ success: Bool, _ message : String?) -> Void)
    {
        APIClient.shared.likeComment(commentId) { response, result, error, code, message  in
            
            if let response = result {
                
                if let success = response["status"] as? Bool {
                    
                    completionHandler(success, message)
                }
                else {
                    completionHandler(false,  error?.localizedDescription ?? message)
                }
            }
            else {
                
                completionHandler(false, error?.localizedDescription ?? message)
            }
        }
    }
    
    func fetchReactions(_ completionHandler: @escaping(_ success: Bool, _ data : Any?, _ message : String?) -> Void)
    {
        
        APIClient.shared.fetchReactions() { response, result, error, code, message  in
            
            if let response = result {
                
                if let data = Mapper<HomeDataModel>().map(JSONObject: response ) {

                    completionHandler(true, data, nil)

                } else {

                    completionHandler(false, nil, nil)
                }
            }
            else {
                
                completionHandler(false, nil, error?.localizedDescription ?? message)
            }
        }
    }
}
