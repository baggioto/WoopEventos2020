//
//  WoopEventsService.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import RxSwift
import Alamofire

class WoopEventsService {
    
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
    
    enum FailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
        case serverError = 500
    }
    
    public func getDetailedEvent(eventId: Int) -> Observable<WoopEvent> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(String(format: self.eventDetailApiUrl, eventId))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let event = try JSONDecoder().decode(WoopEvent.self, from: data)
                            observer.onNext(event)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = FailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
    
    public func getEvents() -> Observable<[WoopEvent]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.eventsApiUrl)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let event = try JSONDecoder().decode([WoopEvent].self, from: data)
                            observer.onNext(event)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = FailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
    
}
