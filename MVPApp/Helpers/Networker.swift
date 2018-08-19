//
//  Networker.swift
//  MVPApp
//
//  Created by Sanad Barjawi on 8/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
import Alamofire
import Swime
/**
 My own statusCode options.
 
 ````
 case OK
 case CREATED
 case NO_CONTENT
 case ACCEPTED
 case NOT_FOUND
 case UNAUTHORIZED
 case BAD_REQUEST
 case CONFLICT
 case SERVICE_UNAVAILABLE
 case BAD_GATEWAY
 ````
 */
enum StatusCode: Int {
    
    /// It request status code the value 200 ok Sucess .
    case  ok = 200
    
    /// It request status code the value 201 created Sucess .
    case created = 201
    
    /// It request status code the value 204 noContent Sucess .
    case noContent = 204
    
    /// It request status code the value 202 accepted Sucess .
    case accepted = 202
    
    /// It request status code the value 404 notFound FAILURE Client side .
    case notFound = 404
    
    /// It request status code the value 401 unauthorized FAILURE Client side .
    case unauthorized = 401
    
    /// It request status code the value 400 badRequest  FAILURE Client side `Error in my params` .
    case badRequest = 400
    
    /// It request status code the value 409 conflict  FAILURE Client side `The Data is existed` .
    case conflict = 409
    
    /// It request status code the value 503 serviceUnavailable  retry request  .
    case  serviceUnavailable = 503
    
    /// It request status code the value 502 badGateway  retry request  .
    case  badGateway = 502
    
}

extension StatusCode {
    
    init?(_ httpResponse: HTTPURLResponse?) {
        guard let statusCodeValue = httpResponse?.statusCode else {
            return nil
        }
        self.init(statusCodeValue)
    }
    
    private init?(_ rawValue: Int) {
        guard let value = StatusCode(rawValue: rawValue) else {
            return nil
        }
        self = value
    }
    
}

private struct Configuration {
    static var serverURL: String {
        return "http://18.232.61.81:8000/api/v1/" /*Bundle.main.infoDictionary!["serverUrl"] as! String*/
        //"http://18.208.198.246/api/v1/"
    }
}
typealias NetworkingCompletionHandler = (Data?, StatusCode?, Swift.Error?) -> Void

protocol Networking {
    func postRequest(endPoint: Endpoint, parameters: Parameters?, headers: HTTPHeaders?, callback: @escaping NetworkingCompletionHandler)
    func getRequest(endPoint: Endpoint, parameters: Parameters?, headers: HTTPHeaders?, callback: @escaping NetworkingCompletionHandler)
    func uploadFile(endPoint: Endpoint, uploadFileModel: UploadFileModel, parameters: Parameters, headers: HTTPHeaders?, callback: @escaping NetworkingCompletionHandler)
    func uploadFiles(endPoint: Endpoint, uploadFileList: [UploadFileModel], parameters: Parameters, headers: HTTPHeaders?, callback: @escaping NetworkingCompletionHandler)
}
// MARK: - Paths Handling

protocol Endpoint {
    var path: String { get }
}

enum URLPath {
    case music
}

extension URLPath: Endpoint {
    var path: String {
        switch self {
        case .music: return "\(Configuration.serverURL)music"
        }
    }
}
extension Networking {
    private func request(method: HTTPMethod, endPoint: Endpoint, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callback: @escaping NetworkingCompletionHandler) {
        guard let url = URL(string: endPoint.path) else {
            return
        }
        
        Alamofire.request(url, method: method, parameters: parameters, headers: headers).validate(statusCode: 200...299)
            .responseData { resposne in
                
                callback(resposne.data, StatusCode(resposne.response), resposne.error)
        }
    }
    private func upload(method: HTTPMethod, endPoint: Endpoint, uploadFileList: [UploadFileModel], parameters: Parameters = [:],
                        headers: HTTPHeaders? = nil, callback: @escaping NetworkingCompletionHandler) {
        guard let url = URL(string: endPoint.path) else {
            return
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            for uploadFileModel in uploadFileList {
                for  index in 0..<uploadFileModel.data.count {
                    if let mimeType = Swime.mimeType(data: uploadFileModel.data[index] ?? Data()) {
                        multipartFormData.append(uploadFileModel.data[index] ?? Data(), withName:
                            String.init(format: uploadFileModel.key.rawValue, "\(index)"),
                                                 fileName: "file.\(mimeType.ext)", mimeType: mimeType.mime)
                    }
                }
            }
        }, to: url, method: method, headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseData { response in
                    callback(response.data, StatusCode(response.response), response.error)
                    }.validate(statusCode: 200...299)
            case .failure(let error):
                callback(nil, StatusCode.serviceUnavailable, error)
                
            }
        }
    }
    func postRequest(endPoint: Endpoint, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callback: @escaping NetworkingCompletionHandler) {
        
        request(method: .post, endPoint: endPoint, parameters: parameters, headers: headers, callback: callback)
    }
    
    func getRequest(endPoint: Endpoint, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callback: @escaping NetworkingCompletionHandler) {
        
        request(method: .get, endPoint: endPoint, parameters: parameters, headers: headers, callback: callback)
    }
    
    func uploadFile(endPoint: Endpoint, uploadFileModel: UploadFileModel, parameters: Parameters = [:], headers: HTTPHeaders?, callback: @escaping NetworkingCompletionHandler) {
        
        upload(method: .post, endPoint: endPoint, uploadFileList: [uploadFileModel], parameters: parameters, headers: headers, callback: callback)
    }
    func uploadFiles(endPoint: Endpoint, uploadFileList: [UploadFileModel], parameters: Parameters = [:], headers: HTTPHeaders?, callback: @escaping NetworkingCompletionHandler) {
        
        upload(method: .post, endPoint: endPoint, uploadFileList: uploadFileList, parameters: parameters, headers: headers, callback: callback)
    }
}

struct APIHelper: Networking { }
