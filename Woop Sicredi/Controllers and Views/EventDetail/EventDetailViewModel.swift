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
    private var loaderShouldAppear = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        //        input variables
        let onViewDidLoad: PublishRelay<Void>
        let backButtonPressed: PublishRelay<Void>
        let shareButtonPressed: PublishRelay<Void>
    }
    
    struct Output {
        // Should create outputs
        let shouldAppearLoaderView: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        // Handle transformation between input into output
        triggerOnViewDidLoad(input.onViewDidLoad.asObservable())
        setupBackButtonAction(input.backButtonPressed.asObservable())
        setupShareButtonAction(input.shareButtonPressed.asObservable())
        
        let shouldAppearLoaderView = setupShouldAppearLoaderView()
        return Output(shouldAppearLoaderView: shouldAppearLoaderView)
    }
    
    init(eventId: Int, service: WoopEventsServiceProtocol, controller: UINavigationController) {
        self.eventId = BehaviorRelay<Int?>(value: eventId)
        self.service = service
        self.controller = controller
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
            .do(onNext: activateLoaderShouldAppear)
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
                self?.resetLoaderShouldAppear()
                }, onError: { [weak self] _ in
                    //toast
                    self?.resetLoaderShouldAppear()
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
