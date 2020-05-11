//
//  WoopRequestErrorModel.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WoopRequestErrorModel: Error {
    
    var statusCode: Int = 500
    var error: String = ""
    var errorDescription: String = "Não foi possível efetuar a operação. Por favor, tente mais tarde."
    var originalResponse: DataResponse<Any>? = nil
    
    init(response: DataResponse<Any>? = nil) {
        if let res = response {
            let json = res.jsonValue
            self.statusCode = res.response?.statusCode ?? self.statusCode
            self.error = json["error"].string ?? self.error
            self.errorDescription = json["error_description"].string ?? self.errorDescription
            self.originalResponse = res
        }
    }
}
