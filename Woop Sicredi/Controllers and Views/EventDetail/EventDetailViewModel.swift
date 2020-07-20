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
    var backgroundImage = BehaviorRelay<UIImage?>(value: nil)
    private var loaderShouldAppear = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        //        input variables
        let onViewDidLoad: PublishRelay<Void>
        let checkinButtonPressed: PublishRelay<Void>
        let backButtonPressed: PublishRelay<Void>
        let shareButtonPressed: PublishRelay<Void>
    }
    
    struct Output {
        // Should create outputs
        let shouldAppearLoaderView: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        // Handle transformation between input into output
        setupOnViewDidLoad(input.onViewDidLoad.asObservable())
        setupBackButtonAction(input.backButtonPressed.asObservable())
        setupShareButtonAction(input.shareButtonPressed.asObservable())
        setupCheckinButtonAction(input.checkinButtonPressed.asObservable())
        setupBackgroundImageBinding()
        
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
    
    private func setupOnViewDidLoad(_ onViewDidLoad: Observable<Void>){
        onViewDidLoad
            .do(onNext: activateLoaderShouldAppear)
            .subscribe(onNext: retrieveEventInfo)
            .disposed(by: disposeBag)
    }
    
    private func setupCheckinButtonAction(_ checkinButtonPressed: Observable<Void>){
        
        checkinButtonPressed
            .withLatestFrom(event)
            .ignoreNil()
            .subscribe(onNext: navigateToCheckin)
            .disposed(by: disposeBag)
    }
    
    private func setupBackgroundImageBinding() {
        event
            .asObservable()
            .ignoreNil()
            .map{$0.image}
            .map{URL(string: $0)}
            .ignoreNil()
            .map{try? UIImage(data: Data(contentsOf: $0))}
            .ignoreNil()
            .map(backgroundImage.accept)
            .subscribe()
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
                    self?.controller.visibleViewController?.view.makeToast("Erro ao obter informações do evento. Por favor, tente novamente.")
                    self?.resetLoaderShouldAppear()
            }).disposed(by: disposeBag)
        
    }
    
    private func navigateToCheckin(_ event: WoopEvent) {
        let viewModel = CheckinViewModel(service: service, controller: controller, event: event)
        let vc = CheckinViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .formSheet
        controller.present(vc, animated: true, completion: nil)
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
