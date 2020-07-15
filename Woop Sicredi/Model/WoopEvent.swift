//
//  Event.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation

struct WoopEvent: Decodable {
    var date:Date
    var image:String
    var eventDescription:String
    var people:[People]
    var cupons:[Cupon]
    var price:Double
    var eventId:String
    var title:String
    var longitude:Double
    var latitude:Double
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case image = "image"
        case eventDescription = "description"
        case people = "people"
        case cupons = "cupons"
        case price = "price"
        case eventId = "id"
        case title = "title"
        case longitude = "longitude"
        case latitude = "latitude"
    }
    
}

extension WoopEvent {
    static func eventMock() -> Self {
        .init(date: Date(),
              image: "",
              eventDescription: "",
              people: [],
              cupons: [],
              price: 50,
              eventId: "",
              title: "",
              longitude: 5,
              latitude: 5)
    }
}
