//
//  People.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation

struct People: Decodable {
    var peopleId:String
    var eventId:String
    var name:String
    var picture:String
    
    enum CodingKeys: String, CodingKey {
        case peopleId = "id"
        case eventId = "eventId"
        case name = "name"
        case picture = "picture"
    }
    
}
