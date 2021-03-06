//
//  Client.swift
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
import Buy
import Pay

final class Client {
    
    static let shopDomain = "bjjhq-prod.myshopify.com"
    static let apiKey     = "b4eb662d2c96cd94524fadb7a305fd9a"
//    static let apiKey     = "b3c912ade8c3ca23e13dbca8467f83b9"
    static let merchantID = "merchant.shopify.bjjhqq"
    static let locale   = Locale(identifier: "en-US")
    
    static let shared = Client()
    
    private let client: Graph.Client = Graph.Client(shopDomain: Client.shopDomain, apiKey: Client.apiKey, locale: Client.locale)
    
    // ----------------------------------
    //  MARK: - Init -
    //
    private init() {
//        self.client.cachePolicy = .cacheFirst(expireIn: 3600)
    }
    
    // ----------------------------------
    //  MARK: - Customers -
    //
    
    @discardableResult
    func createCustomer(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Storefront.Customer?, String?) -> Void) -> Task {
        
        let mutation = ClientQuery.mutationForSignup(email: email, password: password, firstName: firstName, lastName: lastName)
        let task = self.client.mutateGraphWith(mutation) { (mutation, error) in
            error.debugPrint()
            
            if let customer = mutation?.customerCreate?.customer {
                completion(customer, nil)
            } else {
                let errors = mutation?.customerCreate?.customerUserErrors ?? []
                print("Failed to create customer: \(errors)")
                let errorDetail = errors[0].message
                completion(nil, errorDetail)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func login(email: String, password: String, completion: @escaping (String?, String?) -> Void) -> Task {
        
        let mutation = ClientQuery.mutationForLogin(email: email, password: password)
        let task     = self.client.mutateGraphWith(mutation) { (mutation, error) in
            error.debugPrint()
            
            if let container = mutation?.customerAccessTokenCreate?.customerAccessToken {
                completion(container.accessToken, nil)
            } else {
                let errors = mutation?.customerAccessTokenCreate?.customerUserErrors ?? []
                print("Failed to login customer: \(errors)")
                let errorDetail = "Wrong email or password"
                completion(nil, errorDetail)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func logout(accessToken: String, completion: @escaping (Bool) -> Void) -> Task {
        
        let mutation = ClientQuery.mutationForLogout(accessToken: accessToken)
        let task     = self.client.mutateGraphWith(mutation) { (mutation, error) in
            error.debugPrint()
            
            if let deletedToken = mutation?.customerAccessTokenDelete?.deletedAccessToken {
                completion(deletedToken == accessToken)
            } else {
                let errors = mutation?.customerAccessTokenDelete?.userErrors ?? []
                print("Failed to logout customer: \(errors)")
                completion(false)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchCustomerAndOrders(limit: Int = 25, after cursor: String? = nil, accessToken: String, completion: @escaping ((customer: CustomerViewModel, orders: PageableArray<OrderViewModel>)?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCustomer(limit: limit, after: cursor, accessToken: accessToken)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let customer = query?.customer {
                let viewModel   = customer.viewModel
                let collections = PageableArray(
                    with:     customer.orders.edges,
                    pageInfo: customer.orders.pageInfo
                )
                completion((viewModel, collections))
            } else {
                print("Failed to load customer and orders: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    @discardableResult
    func changePassword(accessToken: String,firstName:String,lastName:String, password:String, completion: @escaping (String?,String?) -> Void) -> Task {
        
        let query = ClientQuery.mutationForChangePassword(accessToken: accessToken, firstName: firstName, lastName: lastName, password: password)
        let task  = self.client.mutateGraphWith(query) { (query, error) in
            error.debugPrint()
            if error == nil {
                completion("Password change Succefully",nil)
            }
            else {
                completion(nil,"Password not change")
            }
        }
        
        task.resume()
        return task
    }
    @discardableResult
    func addAddress(accessToken:String,address1:String,address2:String,country:String,postalCode:String,city:String,province:String, completion: @escaping (String?,String?) -> Void) -> Task {
        
        let query = ClientQuery.mutationForAddAddress(accessToken: accessToken, address1: address1, address2: address2, country: country, postalCode: postalCode, city: city, province: province)
        
        let task  = self.client.mutateGraphWith(query) { (query, error) in
            error.debugPrint()
            completion("Done",nil)
        }
        
        task.resume()
        return task
    }
    @discardableResult
    func updateSelectedAddress(accessToken:String,address1:String,address2:String,country:String,postalCode:String,city:String,province:String,id:String, completion: @escaping (String?,String?) -> Void) -> Task {
        
        let query = ClientQuery.mutationForUpdateCurrentAddAddress(accessToken: accessToken, address1: address1, address2: address2, country: country, postalCode: postalCode, city: city, province: province, id: id)
        
        let task  = self.client.mutateGraphWith(query) { (query, error) in
            error.debugPrint()
            completion("Done",nil)
        }
        
        task.resume()
        return task
    }
    @discardableResult
    func updateUser(accessToken:String,firstName:String,lastName:String,email:String, completion: @escaping (String?,String?) -> Void) -> Task {
        
        let query = ClientQuery.mutationForUpadateUser(accessToken: accessToken, firstName: firstName, lastName: lastName, email: email)
        
        let task  = self.client.mutateGraphWith(query) { (query, error) in
            error.debugPrint()
            completion("Done",nil)
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func deleteUserAddress(accessToken:String,addressId:String, completion: @escaping (String?,String?) -> Void) -> Task {
        
        let query = ClientQuery.mutationForDeleteAddress(accessToken:accessToken,id:addressId)
        
        let task  = self.client.mutateGraphWith(query) { (query, error) in
            error.debugPrint()
            completion("Done",nil)
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func webCheckOut(id:String, completion: @escaping (URL?,Graph.QueryError?) -> Void) -> Task {
        
        let query = ClientQuery.mutationForCheckout(accessToken: "", quantity: 1, id: id)
        let task  = self.client.mutateGraphWith(query) { (query, error) in
            
            completion(query?.checkoutCreate?.checkout?.webUrl,error)
            
            error.debugPrint()
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateDefaultAddress(accessToken:String,addressID:String, completion: @escaping (Storefront.MailingAddressConnection?,Storefront.MailingAddress?) -> Void) -> Task {
        
        let query = ClientQuery.mutationForDefaultAddress(accessToken: accessToken, addressID: addressID)
        
        let task  = self.client.mutateGraphWith(query) { (query, error) in
            error.debugPrint()
            let data = query?.customerDefaultAddressUpdate?.customer?.addresses
            completion(data,query?.customerDefaultAddressUpdate?.customer?.defaultAddress)
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchAddress(completion: @escaping ([Storefront.MailingAddressEdge]?,Storefront.MailingAddress?) -> Void) -> Task {
        
        let query = ClientQuery.queryForAdresses()
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            let data = query?.customer?.addresses.edges
            completion(data,query?.customer?.defaultAddress)
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchCustomer(accessToken: String, completion: @escaping (_ customer: CustomerViewModel?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCustomer(accessToken: accessToken)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let customer = query?.customer {
                let viewModel   = customer.viewModel
                
                completion((viewModel))
            } else {
                print("Failed to load customer and orders: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Shop -
    //
    @discardableResult
    func fetchShopName(completion: @escaping (String?) -> Void) -> Task {
        
        let query = ClientQuery.queryForShopName()
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                completion(query.shop.name)
            } else {
                print("Failed to fetch shop name: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchOrders(accessToken:String,orders:Int32,completion: @escaping ([Storefront.OrderEdge]?,Storefront.PageInfo?) -> Void) -> Task {
        
        let query = ClientQuery.queryForOrders(accessToken: accessToken, getOrders:orders )
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                completion(query.customer?.orders.edges, query.customer?.orders.pageInfo)
            } else {
                print("Failed to fetch shop name: \(String(describing: error))")
                completion(nil,nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchShopURL(completion: @escaping (URL?) -> Void) -> Task {
        
        let query = ClientQuery.queryForShopURL()
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                completion(query.shop.primaryDomain.url)
            } else {
                print("Failed to fetch shop url: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Collections -
    //
    @discardableResult
    func fetchCollections(limit: Int = 25, after cursor: String? = nil, productLimit: Int = 25, productCursor: String? = nil, completion: @escaping (PageableArray<CollectionViewModel>?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCollections(limit: limit, after: cursor, productLimit: productLimit, productCursor: productCursor)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                let collections = PageableArray(
                    with:     query.collections.edges,
                    pageInfo: query.collections.pageInfo
                )
                completion(collections)
            } else {
                print("Failed to load collections: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Products -
    //
    @discardableResult
    func fetchProducts(in collection: CollectionViewModel, limit: Int = 25, after cursor: String? = nil, completion: @escaping (PageableArray<ProductViewModel>?) -> Void) -> Task {
        
        let query = ClientQuery.queryForProducts(in: collection, limit: limit, after: cursor)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query,
                let collection = query.node as? Storefront.Collection {
                
                let products = PageableArray(
                    with:     collection.products.edges,
                    pageInfo: collection.products.pageInfo
                )
                completion(products)
                
            } else {
                print("Failed to load products in collection (\(collection.model.node.id.rawValue)): \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    
    @discardableResult
    func fetchProductsDirectly(limit: Int = 25, after cursor: String? = nil, completion: @escaping (PageableArray<ProductViewModel>?) -> Void) -> Task {
        
        let query = ClientQuery.queryForProductsDirectly(limit: limit, after: cursor)
        let task  = self.client.queryGraphWith(query) { (response, error) in
            error.debugPrint()
            
            if let responseProducts = response?.products {
              
               
                let products = PageableArray(
                    with:     responseProducts.edges,
                    pageInfo: responseProducts.pageInfo
                )
                
                let encoded = products.items[0].id
                let decodedData = Data(base64Encoded: encoded)!
                _ = String(data: decodedData, encoding: .utf8)
                
                completion(products)
                
            } else {
                print("Failed to load products : \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchSignleProduct(productId: String, completion: @escaping (Storefront.Product?) -> Void) -> Task {
        
        let query = ClientQuery.getProductById(productId: "40419962224847")
        let task  = self.client.queryGraphWith(query) { (response, error) in
            error.debugPrint()
            
            if let responseProducts = response?.product {

//                let products = PageableArray(
//                    with:     responseProducts.edges,
//                    pageInfo: responseProducts.pageInfo
//                )
                
//                let encoded = products.items[0].id
//                let decodedData = Data(base64Encoded: encoded)!
//                let decodedString = String(data: decodedData, encoding: .utf8)
                
                let encoded = responseProducts.id
                let decodedData = Data(base64Encoded: encoded.rawValue)!
                let decodedString = String(data: decodedData, encoding: .utf8)
                
                completion(responseProducts)
                
            } else {
                print("Failed to load products : \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    
    // ----------------------------------
    //  MARK: - Discounts -
    //
    @discardableResult
    func applyDiscount(_ discountCode: String, to checkoutID: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForApplyingDiscount(discountCode, to: checkoutID)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            completion(response?.checkoutDiscountCodeApplyV2?.checkout?.viewModel)
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func applyForReset(email:String, completion: @escaping (String?) -> Void) -> Task {
        let mutation = Storefront.buildMutation { $0
                .customerRecover(email: email) { $0
                
                .customerUserErrors { $0
                .field().message()
                }
                }
        }
        let task = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            completion("true")
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Gift Cards -
    //
    @discardableResult
    func applyGiftCard(_ giftCardCode: String, to checkoutID: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForApplyingGiftCard(giftCardCode, to: checkoutID)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            completion(response?.checkoutGiftCardsAppend?.checkout?.viewModel)
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Checkout -
    //
    @discardableResult
    func createCheckout(with cartItems: [CartItem], completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForCreateCheckout(with: cartItems)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            completion(response?.checkoutCreate?.checkout?.viewModel)
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingPartialShippingAddress address: PayPostalAddress, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingPartialShippingAddress: address)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutShippingAddressUpdateV2?.checkout,
                let _ = checkout.shippingAddress {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingCompleteShippingAddress address: PayAddress, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingCompleteShippingAddress: address)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutShippingAddressUpdateV2?.checkout,
                let _ = checkout.shippingAddress {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingShippingRate shippingRate: PayShippingRate, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingShippingRate: shippingRate)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutShippingLineUpdate?.checkout,
                let _ = checkout.shippingLine {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func pollForReadyCheckout(_ id: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {

        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            return (response?.node as? Storefront.Checkout)?.ready ?? false == false
        }
        
        let query = ClientQuery.queryForCheckout(id)
        let task  = client.queryGraphWith(query, cachePolicy: .networkOnly, retryHandler: retry) { response, error in
            error.debugPrint()
            
            if let checkout = response?.node as? Storefront.Checkout {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingEmail email: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingEmail: email)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutEmailUpdateV2?.checkout,
                let _ = checkout.email {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, associatingCustomer accessToken: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        
        let mutation = ClientQuery.mutationForUpdateCheckout(id, associatingCustomer: accessToken)
        let task     = self.client.mutateGraphWith(mutation) { (mutation, error) in
            error.debugPrint()
            
            if let checkout = mutation?.checkoutCustomerAssociateV2?.checkout {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchShippingRatesForCheckout(_ id: String, completion: @escaping ((checkout: CheckoutViewModel, rates: [ShippingRateViewModel])?) -> Void) -> Task {
        
        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            
            if let checkout = response?.node as? Storefront.Checkout {
                return checkout.availableShippingRates?.ready ?? false == false || checkout.ready == false
            } else {
                return false
            }
        }
        
        let query = ClientQuery.queryShippingRatesForCheckout(id)
        let task  = self.client.queryGraphWith(query, cachePolicy: .networkOnly, retryHandler: retry) { response, error in
            error.debugPrint()
            
            if let response = response,
                let checkout = response.node as? Storefront.Checkout {
                completion((checkout.viewModel, checkout.availableShippingRates!.shippingRates!.viewModels))
            } else {
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    func completeCheckout(_ checkout: PayCheckout, billingAddress: PayAddress, applePayToken token: String, idempotencyToken: String, completion: @escaping (PaymentViewModel?) -> Void) {
        
        let mutation = ClientQuery.mutationForCompleteCheckoutUsingApplePay(checkout, billingAddress: billingAddress, token: token, idempotencyToken: idempotencyToken)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let payment = response?.checkoutCompleteWithTokenizedPaymentV3?.payment {
                
                print("Payment created, fetching status...")
                self.fetchCompletedPayment(payment.id.rawValue) { paymentViewModel in
                    completion(paymentViewModel)
                }
                
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func fetchCompletedPayment(_ id: String, completion: @escaping (PaymentViewModel?) -> Void) {
        
        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            
            if let payment = response?.node as? Storefront.Payment {
                print("Payment not ready yet, retrying...")
                return !payment.ready
            } else {
                return false
            }
        }
        
        let query = ClientQuery.queryForPayment(id)
        let task  = self.client.queryGraphWith(query, retryHandler: retry) { query, error in
            
            if let payment = query?.node as? Storefront.Payment {
                print("Payment error: \(payment.errorMessage ?? "none")")
                completion(payment.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}

// ----------------------------------
//  MARK: - GraphError -
//
extension Optional where Wrapped == Graph.QueryError {
    
    func debugPrint() {
        switch self {
        case .some(let value):
            print("Graph.QueryError: \(value)")
        case .none:
            break
        }
    }
}
