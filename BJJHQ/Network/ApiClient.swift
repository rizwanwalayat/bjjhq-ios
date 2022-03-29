
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
    
    func Signup(firstName: String, LastName: String, userName: String, email: String, password: String, cPassword: String,fcmToken:String?, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let userParams = ["first_name": firstName, "last_name": LastName, "user_name": userName, "email": email, "password": password, "password_confirmation": cPassword,"fcm_token":fcmToken, "user_mobile_id": uuid]
        
        let params = ["user": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.signup , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func guestUser(uuid: String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let userParams = ["user_mobile_id": uuid]
        let params = ["guest": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.guest , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func updateImage(params : [String: Any],_ completionBlock: @escaping APIClientCompletionHandler) {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        sendRequestUsingMultipart("https://bjjhq.phaedrasolutions.com/api/users/profiles/update_avatar", parameters: params, headers: headers, completionBlock: completionBlock)
    }
    
    func logoutUser(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.logout , parameters: [:] ,httpMethod: .delete , headers: headers, completionBlock: completionBlock)
    }
    
    func SignIn(email: String, password: String, id : String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let userParams = ["email": email, "password": password, "shopify_customer_id": id,"fcm_token":Global.shared.FCMtoken, "user_mobile_id": uuid]
//        let userParams = ["email": email, "password": password,"fcm_token":Global.shared.FCMtoken, "user_mobile_id": uuid]
        let params = ["user": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.signin , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    func ContactUs(body: String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        let userParams = ["body": body]
        let params = ["contact_us": userParams] as [String: AnyObject]
        _ = sendRequest(APIRoutes.contactUS , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    func updateUser(firstName: String, lastName: String, bio : String,username:String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        let userParams = ["first_name": firstName, "last_name": lastName, "bio": bio,"user_name":username,"fcm_token":Global.shared.FCMtoken]
        
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
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.current_deal , parameters: [:] ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    
    func checkEmail(email:String,_ completionBlock: @escaping APIClientCompletionHandler)
    {
        _ = sendRequest(APIRoutes.emailCheck+"?email=\(email)" , parameters: [:] ,httpMethod: .get , headers: nil, completionBlock: completionBlock)
    }
    
    func fetchNotificationSetting(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.NotificationSetting , parameters: [:] ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func fetchReminderHours(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        _ = sendRequest(APIRoutes.reminderHours , parameters: [:] ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func postNotificationSetting(comments:Bool?,dailyDealNotification:Bool?, dailyDealReminder:Int?,rollingDealNotification:Bool?,rollingDealReminder:Int?,snoozeAlert:Bool?,_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let userParams = ["comment_notifications": comments ?? false, "daily_deal_notifications": dailyDealNotification ?? false,"daily_deal_reminder_time":dailyDealReminder ?? 0, "rolling_deal_notifications": rollingDealNotification ?? false,"rolling_deal_reminder_time":rollingDealReminder ?? 0 ,"snooze_alert":snoozeAlert ?? false] as [String : Any]
        
        let params = ["notification": userParams] as [String: AnyObject]
        
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        _ = sendRequest(APIRoutes.updateNotification , parameters: params ,httpMethod: .patch , headers: headers, completionBlock: completionBlock)
    }
    
    func fetchComments(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        let userParams = ["user_mobile_id": uuid, "user_system_id": userId, "role": role] as [String : Any]
        let params = ["user": userParams] as [String: AnyObject]
        
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.fetchcomments , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    func dislikesComment(_ commentId: Int,_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        let userParams = ["user_mobile_id": uuid, "user_system_id": userId, "comment_id": commentId, "role": role] as [String : Any]
        let params = ["reaction": userParams] as [String: AnyObject]
        
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        
        _ = sendRequest(APIRoutes.dislike , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
//    func editComment(_ commentId: Int,_ completionBlock: @escaping APIClientCompletionHandler)
//    {
//        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        let role = DataManager.shared.getUser()?.user?.role ?? "user"
//        let userId = DataManager.shared.getUser()?.user?.id ?? 0
//
//        let userParams = ["user_mobile_id": uuid, "user_system_id": userId, "comment_id": commentId, "role": role] as [String : Any]
//        let params = ["comment": userParams] as [String: AnyObject]
//
//        let token = DataManager.shared.getLocalToken() ?? ""
//        let headers: HTTPHeaders = ["Authorization" : token]
//
//
//        _ = sendRequest(APIRoutes.editComment , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
//    }
    
    func deleteComment(_ commentId: Int,_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        let userParams = ["user_mobile_id": uuid, "user_system_id": userId, "comment_id": commentId, "role": role] as [String : Any]
        let params = ["comment": userParams] as [String: AnyObject]
        
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        
        _ = sendRequest(APIRoutes.deleteComment , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func likeComment(_ commentId: Int, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let role = DataManager.shared.getUser()?.user?.role ?? "user"
        let userId = DataManager.shared.getUser()?.user?.id ?? 0
        
        let userParams = ["user_mobile_id": uuid, "user_system_id": userId, "comment_id": commentId, "role": role] as [String : Any]
        
        let params = ["reaction": userParams] as [String: AnyObject]
            
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.like , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func fetchReactions(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        _ = sendRequest(APIRoutes.reactions , parameters: [:] ,httpMethod: .get , headers: nil, completionBlock: completionBlock)
    }
    
    func sendComments(mobileId: String, userSystemId: String, parentCommentId: String = "",message: String, role: String,_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        var userParams = ["user_mobile_id": mobileId, "user_system_id": userSystemId, "message": message, "role": role]
        if parentCommentId.count > 0{
            userParams["parent_comment_id"] = parentCommentId
        }
        
        let params = ["comment": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.comments , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func editComments(mobileId: String, commentID: String,userSystemId: String, parentCommentId: String = "",message: String, role: String,_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        var userParams = ["user_mobile_id": mobileId, "user_system_id": userSystemId, "message": message, "role": role,"comment_id":commentID]
        if parentCommentId.count > 0 {
            userParams["parent_comment_id"] = parentCommentId
        }
        
        let params = ["comment": userParams] as [String: AnyObject]
        
        _ = sendRequest(APIRoutes.editComment , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func sendImageComments(mobileId: String, userSystemId: String, parentCommentId: String = "",message: String, role: String, image: UIImage, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        var userParams = ["user_mobile_id": mobileId, "user_system_id": userSystemId, "message": message, "role": role]
        if parentCommentId.count > 0{
            userParams["parent_comment_id"] = parentCommentId
        }
        let thumb2 = image.resized(toWidth: 50.0)!
        let imageData = thumb2.jpegData(compressionQuality: 0.5)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        let params = ["comment": userParams, "image": ["data:image/png;base64,"+imageStr]] as [String: AnyObject]
        _ = sendRequest(APIRoutes.comments , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    func sendImageEditComments(mobileId: String, userSystemId: String, parentCommentId: String = "",message: String, role: String, image: UIImage, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let token = DataManager.shared.getLocalToken() ?? ""
        let headers: HTTPHeaders = ["Authorization" : token]
        
        var userParams = ["user_mobile_id": mobileId, "user_system_id": userSystemId, "message": message, "role": role]
        if parentCommentId.count > 0{
            userParams["parent_comment_id"] = parentCommentId
        }
        let thumb2 = image.resized(toWidth: 50.0)!
        let imageData = thumb2.jpegData(compressionQuality: 0.5)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        let params = ["comment": userParams, "image": ["data:image/png;base64,"+imageStr]] as [String: AnyObject]
        _ = sendRequest(APIRoutes.editComment , parameters: params ,httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
}
