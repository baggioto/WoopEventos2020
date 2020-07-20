//
//  WoopEventsService.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import RxSwift
import Alamofire

enum FailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
    case serverError = 500
}

protocol WoopEventsServiceProtocol {
    func getDetailedEvent(eventId: Int) -> Observable<WoopEvent>
    func getEvents() -> Observable<[WoopEvent]>
    func checkin(name: String, email: String, event: WoopEvent) -> Observable<Bool>
}

class WoopEventsService: WoopEventsServiceProtocol {
    
    private var plist: [String: Any]? = {
        return readFromPlist(name: "ServiceData")
    }()
    
    lazy var baseApiUrl: String = apiUrl
    
    private var eventsApiUrl: String {
        "\(baseApiUrl)/events"
    }
    
    private var eventDetailApiUrl: String {
        "\(baseApiUrl)/events/%d"
    }
    
    private var checkinApiUrl: String {
        "\(baseApiUrl)/checkin"
    }
    
    public func checkin(name: String, email: String, event: WoopEvent) -> Observable<Bool> {
        return Observable.create { [weak self] observer -> Disposable in
            
            guard let checkinUrl = self?.checkinApiUrl else {
                return Disposables.create()
            }
            
            let params: Parameters = [
                "eventId": event.eventId,
                "name": name,
                "email": email
            ]
            
            Alamofire.request(checkinUrl, method: .post, parameters: params)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let event = try JSONDecoder().decode(Bool.self, from: data)
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
    
    public func getDetailedEvent(eventId: Int) -> Observable<WoopEvent> {
        return Observable.create { [weak self] observer -> Disposable in
            
            guard let eventUrl = self?.eventDetailApiUrl else {
                return Disposables.create()
            }
            
            Alamofire.request(String(format: eventUrl, eventId))
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
        return Observable.create { [weak self] observer -> Disposable in
            
            guard let eventApiUrl = self?.eventsApiUrl else {
                return Disposables.create()
            }
            
            Alamofire.request(eventApiUrl)
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

enum WoopEventsServiceMockBehavior {
    case none
    case error
    case success
}

final class WoopEventsServiceMock: WoopEventsServiceProtocol {
    
    var behavior: WoopEventsServiceMockBehavior
    
    init(behavior: WoopEventsServiceMockBehavior) {
        self.behavior = behavior
    }
    
    func getDetailedEvent(eventId: Int) -> Observable<WoopEvent> {
        switch behavior {
        case .success:
            return .just(WoopEvent.eventMock())
        default:
            return .error(FailureReason.unAuthorized)
        }
    }
    
    func getEvents() -> Observable<[WoopEvent]> {
        switch behavior {
        case .success:
            return .just([WoopEvent.eventMock()])
        default:
            return .error(FailureReason.unAuthorized)
        }
    }
    
    func checkin(name: String, email: String, event: WoopEvent) -> Observable<Bool> {
        switch behavior {
        case .success:
            return Observable.of(true)
        default:
            return .error(FailureReason.unAuthorized)
        }
    }
    
}

extension WoopEventsService {
    
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
