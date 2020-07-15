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

enum MainViewModelDoubleBehavior {
    case none
    case error
    case success
}

class MainViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    let events = BehaviorRelay<[WoopEvent]>(value: [])
    var double = BehaviorRelay<MainViewModelDoubleBehavior>(value: .none)
    
    struct Input {
        //        input variables
        let onViewDidLoad: PublishRelay<Void>
    }
    
    struct Output {
        // Should create outputs
    }
    
    func transform(input: Input) -> Output {
        // Handle transformation between input into output
        triggerOnViewDidLoad(input.onViewDidLoad.asObservable())
        
        return Output()
    }
    
    func triggerOnViewDidLoad(_ onViewDidLoad: Observable<Void>){
        onViewDidLoad
            .subscribe(onNext: retrieveEventList)
            .disposed(by: disposeBag)
    }
    
    func retrieveEventList() {
        WoopEventsService
            .sharedInstance
            .getEvents()
            .subscribe(onNext: { [weak self] model in
                self?.events.accept(model)
                self?.double.accept(.success)
                }, onError: { [weak self] _ in
                    //TOAST ?
                    self?.double.accept(.error)
            }).disposed(by: self.disposeBag)
    }
}
