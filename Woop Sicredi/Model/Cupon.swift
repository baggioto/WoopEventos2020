//
//  Cupon.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

struct Cupon: Decodable {
    var eventId:String
    var discount:Double
    var cuponId:String
    
    enum CodingKeys: String, CodingKey {
        case eventId = "eventId"
        case discount = "discount"
        case cuponId = "id"
    }
}
