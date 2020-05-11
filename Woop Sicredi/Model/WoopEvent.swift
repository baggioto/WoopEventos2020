//
//  Event.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation

class WoopEvent {
    var date:Int!
    var image:String!
    var eventDescription:String!
    var people:[People]!
    var cupons:[Cupon]!
    var price:Double!
    var eventId:String!
    var title:String!
    var longitude:String!
    var latitude:String!
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return }
        
        self.date = dictionary["date"] as? Int
        self.image = dictionary["image"] as? String
        self.eventDescription = dictionary["description"] as? String
        
        //Parsing Array of People
        
        let peopleDictionary: [[String:Any]] = dictionary["people"] as! [[String : Any]]
        var correctPeople: [People] = []
        
        for currentPerson:[String:Any] in peopleDictionary{
            let correctPerson : People = People(with: currentPerson)
            correctPeople.append(correctPerson)
        }
        
        if(correctPeople.count > 0){
            self.people = correctPeople
        }
        
        //
        
        //Parsing Array of Cupons
        let cuponDictionary: [[String:Any]] = dictionary["cupons"] as! [[String : Any]]
        var correctCupons: [Cupon] = []
        
        for currentCupon:[String:Any] in cuponDictionary{
            let correctCupon : Cupon = Cupon(with: currentCupon)
            correctCupons.append(correctCupon)
        }
        
        if(correctCupons.count > 0){
            self.cupons = correctCupons
        }
        //
        self.price = dictionary["price"] as? Double
        self.eventId = dictionary["id"] as? String
        self.title = dictionary["title"] as? String
        self.longitude = dictionary["longitude"] as? String
        self.latitude = dictionary["latitude"] as? String
        
    }
    
}
