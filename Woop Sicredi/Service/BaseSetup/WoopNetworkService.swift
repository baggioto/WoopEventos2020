//
//  WoopNetworkService.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WoopNetworkService {
    
    func requestJson(
        _ url: String,
        method: Alamofire.HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        completion: @escaping (WoopRequestErrorModel?, DataResponse<Any>?) -> Void) {
        
        guard let request = try? Alamofire.SessionManager.default.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers) else {
            let error = WoopRequestErrorModel.init()
            error.errorDescription = "Application Error"
            URLCache.shared.removeCachedResponses(since: Date.distantPast)
            completion(error, nil)
            return
        }
        
        request.responseJSON { (dataResponse) in
            let statusCode = dataResponse.response?.statusCode ?? 0
            
            if statusCode >= 200 && statusCode <= 299 {
                URLCache.shared.removeCachedResponses(since: Date.distantPast)
                completion(nil, dataResponse)
                return
            }
            
            let error = WoopRequestErrorModel(response: dataResponse)
            URLCache.shared.removeCachedResponses(since: Date.distantPast)
            completion(error, nil)
        }
    }
    
}
