//
//  MainViewModel.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 04/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

enum MainViewModelDoubleMockBehavior {
    case none
    case error
    case success
}

class MainViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    
    let events = BehaviorRelay<[WoopEvent]>(value: [])
    var double = BehaviorRelay<MainViewModelDoubleMockBehavior>(value: .none)
    var selectedEventId = BehaviorRelay<Int?>(value: nil)
    
    private var service: WoopEventsServiceProtocol
    private var controller: UINavigationController
    
    struct Input {
        //        input variables
        let onViewDidLoad: PublishRelay<Void>
        let didSelectEvent: PublishRelay<Void>
    }
    
    struct Output {
        // Should create outputs
    }
    
    func transform(input: Input) -> Output {
        // Handle transformation between input into output
        triggerOnViewDidLoad(input.onViewDidLoad.asObservable())
        setupEventSelection(didSelectEvent: input.didSelectEvent.asObservable())
        
        return Output()
    }
    
    init(service: WoopEventsServiceProtocol, controller: UINavigationController) {
        self.service = service
        self.controller = controller
    }
    
    private func setupEventSelection(didSelectEvent: Observable<Void>) {
        didSelectEvent
        .withLatestFrom(selectedEventId)
        .ignoreNil()
        .map(navigateToEventDetail)
        .subscribe()
        .disposed(by: disposeBag)
    }
    
    func triggerOnViewDidLoad(_ onViewDidLoad: Observable<Void>){
        onViewDidLoad
            .subscribe(onNext: retrieveEventList)
            .disposed(by: disposeBag)
    }
    
    func retrieveEventList() {
        service
            .getEvents()
            .subscribe(onNext: { [weak self] model in
                self?.events.accept(model)
                self?.double.accept(.success)
                }, onError: { [weak self] _ in
                    //TOAST ?
                    self?.double.accept(.error)
            }).disposed(by: self.disposeBag)
    }
    
    private func navigateToEventDetail(_ eventId: Int) {
        let model = EventDetailViewModel(eventId: eventId, service: service, controller: controller)
        let vc = EventDetailViewController(viewModel: model)
        controller.pushViewController(vc, animated: false)
    }
}
