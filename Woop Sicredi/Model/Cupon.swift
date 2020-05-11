//
//  Cupon.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation

class Cupon {
    var eventId:String!
    var dicount:Double!
    var cuponId:String!
    
    init(with dictionary: [String: Any]?){
        guard let dictionary = dictionary else { return }
        
        self.eventId = dictionary["eventId"] as? String
        self.dicount = dictionary["dicount"] as? Double
        self.cuponId = dictionary["id"] as? String
        
    }
}
