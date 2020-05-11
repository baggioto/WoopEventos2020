//
//  People.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation

class People {
    var peopleId:String!
    var eventId:String!
    var name:String!
    var picture:String!
    
    init(with dictionary: [String: Any]?){
        guard let dictionary = dictionary else { return }
        
        self.peopleId = dictionary["id"] as? String
        self.eventId = dictionary["eventId"] as? String
        self.name = dictionary["name"] as? String
        self.picture = dictionary["picture"] as? String
        
    }
    
}
