//
//  WoopEventsService.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class WoopEventsService: NSObject {
    
    private static var _instance: WoopEventsService? = nil
    
    public static var sharedInstance: WoopEventsService {
        get {
            if _instance == nil {
                _instance = WoopEventsService()
            }
            
            return _instance!
        }
    }
    
    private let baseApiUrl: String = WoopBaseService.sharedInstance.apiUrl
    
    private var eventsApiUrl: String {
        "\(baseApiUrl)/events"
    }
    
    private var eventDetailApiUrl: String {
        "\(baseApiUrl)/events/%d"
    }
    
    public func getDetailedEvent(eventId: Int) -> Observable<WoopEvent> {
        return Observable<WoopEvent>.create { (observable) -> Disposable in
            
            WoopUserNetworkService.sharedInstance.requestJson(String(format: self.eventDetailApiUrl, eventId)) { (err, res) in
                if let error = err {
                    print(error)
                    observable.onError(error)
                }
                
                if let data = res?.data {
                    do {
                        
                        let json: [String : Any] = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                        let correctEvent: WoopEvent = WoopEvent(with: json)
                        
                        observable.onNext(correctEvent)
                    } catch {
                        observable.onError(error)
                    }
                }
                observable.onCompleted()
            }
            return Disposables.create{}
        }
    }
    
    public func getEvents() -> Observable<[WoopEvent]> {
        return Observable<[WoopEvent]>.create { (observable) -> Disposable in
            
            WoopUserNetworkService.sharedInstance.requestJson(self.eventsApiUrl) { (err, res) in
                if let error = err {
                    print(error)
                    observable.onError(error)
                }
                
                if let data = res?.data {
                    do {
                        
                        let json: [[String : Any]] = try JSONSerialization.jsonObject(with: data, options: []) as! [[String : Any]]
                        
                        var events: [WoopEvent] = []
                        
                        for event in json {
                            
                            let correctEvent: WoopEvent = WoopEvent(with: event)
                            events.append(correctEvent)
                            
                        }
                        
                        observable.onNext(events)
                    } catch {
                        observable.onError(error)
                    }
                }
                observable.onCompleted()
            }
            return Disposables.create{}
        }
    }
    
}
