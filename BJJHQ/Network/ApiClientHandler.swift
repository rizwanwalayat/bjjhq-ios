
import UIKit
import Alamofire
import ObjectMapper

typealias APIClientCompletionHandler = (_ responce:  HTTPURLResponse?,_ result: AnyObject?, _ error: NSError?,_ statusCode: Bool,_ messsage:String) -> Void

enum APIClientHandlerErrorCode: Int {
    case general = 30001
    case noNetwork = 30002
    case timeOut = 30003
    case invalidToken = 401
}

let APIClientHandlerErrorDomain = ""
let APIClientHandlerDefaultErrorDescription = "Operation failed" //"Operation failed"

class APIClientHandler: TSAPIClient {
    var status : Bool = true
    var message : String = "Data not fetched"
    
    func sendRequestUsingMultipart (_ url: String, parameters: [String : AnyObject]?, httpMethod: HTTPMethod = .patch, headers: [String : String]?, completionBlock: @escaping APIClientCompletionHandler) {
        var parameters = parameters
        
        print("\(String(describing: url))")

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters ?? [:] {
                
                if key == "image" {
                    let images = value as! [UIImage]
                    
                    var count = 0
                    for image in images {
                        
                        count = count + 1
                        let data = image.jpegData(compressionQuality: 0.5) //jpeg(.lowest)
                        multipartFormData.append(data!, withName: "image", fileName: "image\(count).jpeg", mimeType: "image/jpeg")
                    }
                    parameters?.removeValue(forKey: "image")
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }
            
        }, usingThreshold: 0, to: url, method: httpMethod, headers: headers, encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
                
            case .success(let upload, _ , _):
                

                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success(let resultData):
                        self.showRequestDetailForSuccess(responseObject: response)
                        completionBlock(response.response,resultData as AnyObject, nil, self.status,self.message)
                        
                    case .failure(let error):
                        self.showRequestDetailForFailure(responseObject: response)
                        completionBlock(response.response,error as AnyObject, error as NSError, self.status,self.message)
                    }
                    
                }
            case .failure:
                break
            }
        })
    }
    
    
    func rawRequest(url: String, method: HTTPMethod, parameters: [String:AnyObject]?, headers: [String : String]?, completionBlock: @escaping APIClientCompletionHandler) {
        
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        request.responseJSON { (response) in
            switch response.result {
                
            case .success(let data):
//                print(data)
                completionBlock(response.response,data as AnyObject, nil, self.status,self.message)
            case .failure(let error):
                print(error.localizedDescription)
                completionBlock(response.response,nil, error as NSError, self.status,self.message)
            }
        }
    }
    
    
    func sendRequest(_ endPoint: String,
                     parameters: [String : AnyObject]?,
                     httpMethod: HTTPMethod = .get,
                     headers: [String : String]?,
                     completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let request = self.serverRequest(APIRoutes.baseUrl + endPoint, parameters: parameters, httpMethod: httpMethod, headers: headers) { (response, result, error) in

            if error != nil {
                var apiError = error

                if error?.code == NSURLErrorNotConnectedToInternet {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "No network found"]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.noNetwork.rawValue, andErrorInfo: userInfo)

                } else if error?.code == 401 {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "Token problem"]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.invalidToken.rawValue, andErrorInfo: userInfo)
                    
                } else {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "Server Did Not Respond \ntry after some time ...."]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.timeOut.rawValue, andErrorInfo: userInfo)
                }

                DispatchQueue.main.async { // Correct
                    completionBlock(response,nil, apiError, self.status,self.message)
                }

            } else {

                var sendError = false
                var sendMessage = false
                var status = false
                var isError = false
                var errorMessage = ""
                var message = ""
                var resultError: NSError?
                var resultData: AnyObject?

                let newResult = ["result" : result]
                if let responseHandler = Mapper<VTResponseHandler>().map(JSONObject:newResult) {
                    status = responseHandler.status
                    isError = responseHandler.isError
                    errorMessage = responseHandler.error
                    message = responseHandler.message
                    resultData = responseHandler.data
                    if !isError {
                        status  = responseHandler.status
                        self.status = status
                    }

                    if   !isError {
                        resultData = responseHandler.data

                        if resultData == nil {
                            resultData = true as AnyObject?
                        }

                    } else if isError && message != "" {
                        sendMessage = true

                    } else {
                        sendError = true
                    }

                } else {
                    sendError = true
                }

                if sendError {
                    resultError = self.createError(errorMessage)

                    DispatchQueue.main.async { // Correct
                        completionBlock(response,nil, resultError, status,message)
                    }

                } else if sendMessage {
                    resultError = self.createError(message)

                    if resultData == nil {
                        resultData = true as AnyObject?
                    }

                    DispatchQueue.main.async { // Correct
                        completionBlock(response,resultData, resultError, status,message)
                    }
 
                } else {

                    DispatchQueue.main.async { // Correct
                        completionBlock(response,resultData, nil, status,message)
                    }
                }
            }
        }

        return request
    }

    // MARK: - Private methods

    func createError(_ errorDescription: String) -> NSError {
        var description = APIClientHandlerDefaultErrorDescription

        //print(errorDescription)
        if errorDescription.count > 0 {
            description = errorDescription
        }

        let userInfo : [String: Any] = [NSLocalizedDescriptionKey : description]

        return createErrorWithErrorCode(APIClientHandlerErrorCode.general.rawValue, andErrorInfo: userInfo)
    }

    func createErrorWithErrorCode(_ code: Int, andErrorInfo info: [String: Any]?) -> NSError {
        return NSError(domain: APIClientHandlerErrorDomain, code: code, userInfo: info)
    }
}
