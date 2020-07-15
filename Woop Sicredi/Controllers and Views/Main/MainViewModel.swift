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
    
    private func triggerOnViewDidLoad(_ onViewDidLoad: Observable<Void>){
        onViewDidLoad
            .do(onNext: activateLoaderShouldAppear)
            .subscribe(onNext: retrieveEventList)
            .disposed(by: disposeBag)
    }
    
    private func retrieveEventList() {
        
        WoopEventsService
            .sharedInstance
            .getEvents()
            .subscribe(onNext: { [weak self] model in
                self?.events.accept(model)
                self?.resetLoaderShouldAppear()
                }, onError: { [weak self] _ in
                    //TOAST ?
                    self?.resetLoaderShouldAppear()
            }).disposed(by: self.disposeBag)
    }
}
