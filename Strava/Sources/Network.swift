//
//  Network.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 07/09/16.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public struct StravaRequest<Value: Mappable> {
    typealias ObjectCompletion = (StravaResponse<Value>) -> Void
    typealias ArrayCompletion = (StravaResponse<[Value]>) -> Void
    typealias SuccessConfirmation = (Bool, StravaError?) -> Void
    
    var params = Parameters()
    var headers = [String: String]()
    var method = HTTPMethod.get
    var url: String?
    var pathComponent: String? // Will be added to base URL
    private (set) var token: String?
    
    mutating func addParam(_ key: String, value: Any?) {
        guard let value = value else {
            print("Warning: Trying to add `nil` HTTP parameter for key \(key)! Action skipped!")
            return
        }
        params[key] = value
    }
    
    mutating func addHeader(_ key: String, value: String?) {
        guard let value = value else {
            print("Warning: Trying to add `nil` HTTP header for key \(key)! Action skipped!")
            return
        }
        headers[key] = value
    }
    
    mutating func addToken(token: String) {
        addHeader("Authorization", value: "Bearer \(token)")
    }
    
    func requestObject(_ completion: @escaping ObjectCompletion) {
        Alamofire.request(reqURL, method: method, parameters: params, headers: headers).validate().responseObject { (response: DataResponse<Value>) in
            var stravaResponse: StravaResponse<Value>
            switch response.result {
            case .success(let value):
                stravaResponse = .Success(value)
            case .failure(let error):
                stravaResponse = .Failure(StravaError(message: error.localizedDescription))
            }
            completion(stravaResponse)
        }
    }
    
    func requestArray(_ completion: @escaping ArrayCompletion) {
        Alamofire.request(reqURL, method: method, parameters: params, headers: headers).validate().responseArray { (response: DataResponse<[Value]>) in
            var stravaResponse: StravaResponse<[Value]>
            switch response.result {
            case .success(let value):
                stravaResponse = .Success(value)
            case .failure(let error):
                stravaResponse = .Failure(StravaError(message: error.localizedDescription))
            }
            completion(stravaResponse)
        }
    }
    
    func requestWithSuccessConfirmation(_ completion: @escaping SuccessConfirmation) {
        Alamofire.request(reqURL, method: method, parameters: params, headers: headers).validate().response(completionHandler: { (response:DefaultDataResponse) in
            if let error = response.error {
                completion(false, StravaError(message: error.localizedDescription))
                return
            }
            completion(true, nil)
        })
    }
    
    func uploadRequest(data: Data, _ completion: @escaping ObjectCompletion) {
        Alamofire.upload(multipartFormData: { multipartData in
            for (key, value) in self.params {
                multipartData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
            let fileURL = Bundle.main.url(forResource: "gpx", withExtension: "gpx")!
            multipartData.append(fileURL, withName: "file", fileName: "file.gpx", mimeType: "octet/stream")
        }, to: reqURL, method: method, headers: headers) { encodingResult in
            
        }
    }
    
    private var reqURL: String {
        if let url = url {
            return url
        } else {
            return StravaClient.baseURL + (pathComponent ?? "")
        }
    }
}


public enum StravaResponse<Value>{
    case Success(Value)
    case Failure(StravaError)
}

public struct StravaError {
    public var message: String?
}
