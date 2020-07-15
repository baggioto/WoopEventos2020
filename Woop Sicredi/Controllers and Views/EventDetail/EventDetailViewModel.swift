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
    private var loaderShouldAppear = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        //        input variables
        let onViewDidLoad: Observable<Void>
    }
    
    struct Output {
        // Should create outputs
        let shouldAppearLoaderView: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        // Handle transformation between input into output
        triggerOnViewDidLoad(input.onViewDidLoad)
        let shouldAppearLoaderView = setupShouldAppearLoaderView()
        
        return Output(shouldAppearLoaderView: shouldAppearLoaderView)
    }
    
    private func setupShouldAppearLoaderView() -> Driver<Bool> {
        return loaderShouldAppear.asDriver(onErrorJustReturn: false)
    }
    
    private func setLoaderShouldAppear(shouldAppear: Bool) {
        loaderShouldAppear.accept(shouldAppear)
    }
    
    private func resetLoaderShouldAppear() {
        setLoaderShouldAppear(shouldAppear: false)
    }
    
    private func activateLoaderShouldAppear() {
        setLoaderShouldAppear(shouldAppear: true)
    }
    
    init(eventId: Int) {
        self.eventId = BehaviorRelay<Int?>(value: eventId)
    }
    
    private func triggerOnViewDidLoad(_ onViewDidLoad: Observable<Void>){
        onViewDidLoad
            .do(onNext: activateLoaderShouldAppear)
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
                self?.resetLoaderShouldAppear()
                }, onError: { [weak self] _ in
                    //toast
                    self?.resetLoaderShouldAppear()
            }).disposed(by: disposeBag)
        
    }
}
