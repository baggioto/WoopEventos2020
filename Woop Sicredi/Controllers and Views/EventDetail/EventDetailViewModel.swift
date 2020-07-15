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
    
    private var service: WoopEventsServiceProtocol
    private var controller: UINavigationController
    private var eventId = BehaviorRelay<Int?>(value: nil)
    var event = BehaviorRelay<WoopEvent?>(value: nil)
    
    struct Input {
        //        input variables
        let onViewDidLoad: PublishRelay<Void>
        let backButtonPressed: PublishRelay<Void>
        let shareButtonPressed: PublishRelay<Void>
    }
    
    struct Output {
        // Should create outputs
    }
    
    func transform(input: Input) -> Output {
        // Handle transformation between input into output
        triggerOnViewDidLoad(input.onViewDidLoad.asObservable())
        setupBackButtonAction(input.backButtonPressed.asObservable())
        setupShareButtonAction(input.shareButtonPressed.asObservable())
        return Output()
    }
    
    init(eventId: Int, service: WoopEventsServiceProtocol, controller: UINavigationController) {
        self.eventId = BehaviorRelay<Int?>(value: eventId)
        self.service = service
        self.controller = controller
    }
    
    private func setupShareButtonAction(_ shareButtonPressed: Observable<Void>) {
        shareButtonPressed
        .subscribe(onNext: shareEvent)
        .disposed(by: disposeBag)
    }
    
    private func setupBackButtonAction(_ backButtonPressed: Observable<Void>) {
        backButtonPressed
        .subscribe(onNext: navigateToPreviousController)
        .disposed(by: disposeBag)
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
        
        service
            .getDetailedEvent(eventId: validEventId)
            .subscribe(onNext: { [weak self] model in
                self?.event.accept(model)
                }, onError: { _ in
                    //toast
            }).disposed(by: disposeBag)
        
    }
    
    private func navigateToPreviousController() {
        controller.popViewController(animated: true)
    }
    
    private func shareEvent() {
        
        guard let eventValue = event.value else {
            return
        }
        
        let textToShare = [ eventValue.eventDescription ]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = controller.visibleViewController?.view
        
        controller.visibleViewController?.present(activityViewController, animated: true, completion: nil)
        
    }
}
