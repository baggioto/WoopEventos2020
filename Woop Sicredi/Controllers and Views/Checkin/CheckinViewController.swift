//
//  CheckinViewController.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 20/07/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CheckinViewController: UIViewController{
    
    private let disposeBag = DisposeBag()
    private var onViewDidLoad = PublishRelay<Void>()
    private var onCheckinPressed = PublishRelay<Void>()
    private var nameText = BehaviorRelay<String>(value: "")
    private var emailText = BehaviorRelay<String>(value: "")
    
    var viewModel: CheckinViewModel
    lazy var viewModelOutput: CheckinViewModel.Output = {
        let input = CheckinViewModel.Input(onViewDidLoad: onViewDidLoad,
                                           onCheckinPressed: onCheckinPressed,
                                           nameText: nameText,
                                           emailText: emailText)
        
        return viewModel.transform(input: input)
    }()
    
    let customView = CheckinView()
    
    // MARK: - Lifecycle methods
    
    public init(viewModel: CheckinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        onViewDidLoad.accept(())
    }
    
    private func setupBindings() {
        setupTitleBinding()
        setupButtonBindings()
        setupTextBindings()
    }
    
    private func setupTextBindings() {
        customView
            .nameTextField
            .rx.text
            .orEmpty
            .bind(to: nameText)
            .disposed(by: disposeBag)
        
        customView
            .emailTextField
            .rx.text
            .orEmpty
            .bind(to: emailText)
            .disposed(by: disposeBag)
    }
    
    private func setupButtonBindings() {
        Observable.combineLatest(viewModelOutput.isEmailValid, viewModelOutput.isNameValid)
            .map{$0.0 && $0.1}
            .bind(to: customView.checkinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        customView
            .checkinButton
            .rx.tap
            .bind(to: onCheckinPressed)
            .disposed(by: disposeBag)
        
        onCheckinPressed
            .subscribe(onNext: hideKeyboard)
            .disposed(by: disposeBag)
    }
    
    private func hideKeyboard() {
        customView.endEditing(true)
    }
    
    private func setupTitleBinding() {
        viewModelOutput
            .title
            .drive(customView.titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
