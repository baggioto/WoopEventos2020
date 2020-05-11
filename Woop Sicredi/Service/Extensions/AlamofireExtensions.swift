//
//  AlamofireExtensions.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    public func withDebugLog() -> Self {
        debugPrint(self)
        
        return self
    }
}

extension Alamofire.SessionManager {
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: Alamofire.HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil) throws
        -> DataRequest
    {
        var urlRequest = try URLRequest(url: url, method: method, headers: headers)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
        return request(encodedURLRequest)
    }
}

