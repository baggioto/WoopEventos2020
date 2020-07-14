//
//  EventDetailViewModel.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 10/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import RxSwift
import RxCocoa

class EventDetailViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    private var eventId = BehaviorRelay<Int?>(value: nil)
    var event = BehaviorRelay<WoopEvent?>(value: nil)
    
    struct Input {
        //        input variables
        let onViewDidLoad: Observable<Void>
    }
    
    struct Output {
        // Should create outputs
    }
    
    func transform(input: Input) -> Output {
        // Handle transformation between input into output
        triggerOnViewDidLoad(input.onViewDidLoad)
        return Output()
    }
    
    
    init(eventId: Int) {
        self.eventId = BehaviorRelay<Int?>(value: eventId)
    }
    
    private func triggerOnViewDidLoad(_ onViewDidLoad: Observable<Void>){
        onViewDidLoad
            .subscribe(onNext: retrieveEventInfo)
            .disposed(by: disposeBag)
    }
    
    private func retrieveEventInfo() {
        
        guard let validEventId = self.eventId.value else {
            return
        }
        
        WoopEventsService
            .sharedInstance
            .getDetailedEvent(eventId: validEventId)
            .subscribe(onNext: { [weak self] model in
                self?.event.accept(model)
                }, onError: { _ in
                    //toast
            }).disposed(by: disposeBag)
        
    }
}
