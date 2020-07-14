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

class MainViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    let events = BehaviorRelay<[WoopEvent]>(value: [])
    
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
    
    private func triggerOnViewDidLoad(_ onViewDidLoad: Observable<Void>){
        onViewDidLoad
            .subscribe(onNext: retrieveEventList)
            .disposed(by: disposeBag)
    }
    
    private func retrieveEventList() {
        WoopEventsService
            .sharedInstance
            .getEvents()
            .subscribe(onNext: { [weak self] model in
                self?.events.accept(model)
                }, onError: { _ in
                    //TOAST ?
            }).disposed(by: self.disposeBag)
        
    }
}
