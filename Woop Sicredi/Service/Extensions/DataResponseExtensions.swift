//
//  DataResponseExtensions.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension DataResponse {
    var isSuccessRequest: Bool {
        if let r = self.response {
            let statusCode = r.statusCode
            
            return statusCode >= 200 && statusCode < 300
        }
        
        return false
    }
    
    var isUnauthorized: Bool! {
        return self.response?.statusCode == 401
    }
    
    var isNotFound: Bool {
        if let r = self.response {
            let statusCode = r.statusCode
            
            return statusCode == 404
        }
        
        return false
    }
    
    var isCancelled: Bool {
        if let error = self.error as NSError?, error.code == NSURLErrorCancelled {
            return true
        }
        
        return false
    }
    
    var jsonValue: JSON {
        return JSON(self.result.value as Any)
    }
}
