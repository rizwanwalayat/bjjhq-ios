
import UIKit
import Alamofire
import ObjectMapper


class Connectivity {
    
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

let APIClientDefaultTimeOut = 40.0

class APIClient: APIClientHandler {
    //    let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
    
    fileprivate var clientDateFormatter: DateFormatter
    var isConnectedToNetwork: Bool?
    
    static var shared: APIClient = {
        let baseURL = URL(fileURLWithPath: APIRoutes.baseUrl)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIClientDefaultTimeOut
        
        let instance = APIClient(baseURL: baseURL, configuration: configuration)
        
        return instance
    }()
    
    // MARK: - init methods
    
    override init(baseURL: URL, configuration: URLSessionConfiguration, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        clientDateFormatter = DateFormatter()
        
        super.init(baseURL: baseURL, configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
        
        //        clientDateFormatter.timeZone = NSTimeZone(name: "UTC")
        clientDateFormatter.dateFormat = "yyyy-MM-dd" // Change it to desired date format to be used in All Apis
    }
    
    
    // MARK: Helper methods
    
    func apiClientDateFormatter() -> DateFormatter {
        return clientDateFormatter.copy() as! DateFormatter
    }
    
    fileprivate func normalizeString(_ value: AnyObject?) -> String {
        return value == nil ? "" : value as! String
    }
    
    fileprivate func normalizeDate(_ date: Date?) -> String {
        return date == nil ? "" : clientDateFormatter.string(from: date!)
    }
    
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func getUrlFromParam(apiUrl: String, params: [String: AnyObject]) -> String {
        var url = apiUrl + "?"
        
        for (key, value) in params {
            url = url + key + "=" + "\(value)&"
        }
        url.removeLast()
        return url
    }
    
    // MARK: - Onboarding
    
    func Signup(firstName: String, LastName: String, userName: String, email: String, password: String, cPassword: String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let userParams = ["first_name": firstName, "last_name": LastName, "user_name": userName, "email": email, "password": password, "password_confirmation": cPassword]
        
        let params = ["user": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.signup , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func guestUser(uuid: String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let userParams = ["uuid": uuid]
        let params = ["guest": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.guest , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func updateImage(params : [String: AnyObject],_ completionBlock: @escaping APIClientCompletionHandler) {
        let token = DataManager.shared.getUserAccessToekn() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        sendRequestUsingMultipart(APIRoutes.updateImage, parameters: params, headers: headers, completionBlock: completionBlock)
    }
    
    func logoutUser(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.logout , parameters: [:] ,httpMethod: .delete , headers: headers, completionBlock: completionBlock)
    }
    
    func SignIn(email: String, password: String, id : String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let userParams = ["email": email, "password": password, "shopify_customer_id": id]
        
        let params = ["user": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.signin , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    func updateUser(firstName: String, lastName: String, bio : String,username:String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        let userParams = ["first_name": firstName, "last_name": lastName, "bio": bio,"user_name":username]
        
        let params = ["profile": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.updateProfile , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    func ChangePassword(email: String, newPassword: String,confirmPassword:String, id : String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let userParams = ["email": email, "new_password": newPassword,"confirm_new_password":confirmPassword, "shopify_customer_id": id]
        
        let params = ["user": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.changePassword , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func fetchCurrentDeal(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getUserAccessToekn() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.current_deal , parameters: [:] ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    
}
