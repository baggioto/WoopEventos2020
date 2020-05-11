//
//  WoopUserNetworkService.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation
import Alamofire

class WoopUserNetworkService: WoopNetworkService {
    
    private static var _instance: WoopUserNetworkService? = nil
    
    public static var sharedInstance: WoopUserNetworkService {
        get {
            if _instance == nil {
                _instance = WoopUserNetworkService()
            }
            
            return _instance!
        }
    }
    
    override private init() {}
    
    var authorizationHeader: String = ""
    
}
