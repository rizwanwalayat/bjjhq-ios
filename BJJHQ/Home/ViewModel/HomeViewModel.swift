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
        

        APIClient.shared.fetchCurrentDeal() { result, error, statusCode, messsage in
            
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
}
