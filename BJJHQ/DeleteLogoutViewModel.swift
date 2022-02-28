//
//  DeleteLogoutViewModel.swift
//  BJJHQ
//
//  Created by MAC on 28/02/2022.
//  Copyright © 2022 Shopify Inc. All rights reserved.
//

import Foundation

class DeleteLogoutViewModel : BaseViewModel {
    
    
    func logoutUser(_ completion: @escaping(_ success: Bool, _ message : String?) -> Void) {
        
        APIClient.shared.logoutUser { result, error, statusCode, messsage in
            if let result = result, error == nil {
                completion(true, messsage)
            }
            completion(false, error?.localizedDescription ?? messsage)
        }
    }
    
}
