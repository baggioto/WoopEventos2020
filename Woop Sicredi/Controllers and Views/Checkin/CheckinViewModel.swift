//
//  CheckinViewModel.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 20/07/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import RxSwift
import RxCocoa
import Toast_Swift

class CheckinViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private var service: WoopEventsServiceProtocol
    private var controller: UINavigationController
    var event = BehaviorRelay<WoopEvent?>(value: nil)
    
    struct Input {
        let onViewDidLoad: PublishRelay<Void>
        let onCheckinPressed: PublishRelay<Void>
        let nameText: BehaviorRelay<String>
        let emailText: BehaviorRelay<String>
    }
    
    struct Output {
        let title: Driver<String>
        let isNameValid: Observable<Bool>
        let isEmailValid: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        setupCheckinAction(input.onCheckinPressed.asObservable(),
                           input.nameText,
                           input.emailText)
        
        let title = setupTitle(input.onViewDidLoad.asObservable())
        let isNameValid = setupNameIsValid(input.nameText.asObservable())
        let isEmailValid = setupEmailIsValid(input.emailText.asObservable())
        
        return Output(title: title,
                      isNameValid: isNameValid,
                      isEmailValid: isEmailValid)
    }
    
    init(service: WoopEventsServiceProtocol, controller: UINavigationController, event: WoopEvent) {
        self.service = service
        self.controller = controller
        self.event = BehaviorRelay<WoopEvent?>(value: event)
    }
    
    private func setupCheckinAction(_ onCheckinPressed: Observable<Void>,
                                    _ nameText: BehaviorRelay<String>,
                                    _ emailText: BehaviorRelay<String>) {
        
        onCheckinPressed
            .withLatestFrom(Observable.combineLatest(nameText.asObservable(),
                                                     emailText.asObservable(),
                                                     event.asObservable().ignoreNil()))
            .map(service.checkin)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.toastSuccess()
                },onError: { [weak self] _ in
                    self?.toastFailure()
            }).disposed(by: disposeBag)
    }
    
    private func setupTitle(_ onViewDidLoad: Observable<Void>) -> Driver<String> {
        return onViewDidLoad
            .withLatestFrom(event)
            .ignoreNil()
            .map{$0.title}
            .asDriver(onErrorJustReturn: "")
    }
    
    private func setupNameIsValid(_ textFieldObservable: Observable<String>) -> Observable<Bool> {
        textFieldObservable
            .map{ string in
                (string.count > 2)
        }
    }
    
    private func setupEmailIsValid(_ textFieldObservable: Observable<String>) -> Observable<Bool> {
        textFieldObservable
            .map{ string in
                ((string.count > 3) && string.isValidEmail())
        }
    }
    
    private func toastSuccess() {
        controller.dismiss(animated: true, completion: { [weak self] in
            self?.controller.visibleViewController?.view.makeToast("Check-in feito com sucesso!")
        })
    }
    
    private func toastFailure() {
        controller.dismiss(animated: true, completion: { [weak self] in
            self?.controller.visibleViewController?.view.makeToast("Erro ao finalizar o check-in, tente novamente mais tarde.")
        })
    }
    
}
