//
//  WoopService.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation

class WoopBaseService {
    
    static private var _instance: WoopBaseService? = nil
    
    static var sharedInstance: WoopBaseService! {
        get {
            if WoopBaseService._instance == nil {
                WoopBaseService._instance = WoopBaseService()
            }
            
            return WoopBaseService._instance
        }
    }
    
    private var plist: [String: Any]? = {
        return readFromPlist(name: "ServiceData")
    }()
    
    public static func readFromPlist(name: String) -> [String: Any] {
        if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = ((try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]) as [String : Any]??) {
                return result!
            }
        }
        
        return [:]
    }
    
    var apiUrl: String! {
        get {
            
            if let urls = self.plist?["API_URL"] as? String {
                return urls
            }
            
            return ""
        }
    }
    
}
