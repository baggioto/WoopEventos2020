//
//  EventDetailViewController.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 10/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import RxSwift
import RxCocoa

class EventDetailViewController: UIViewController{
    
    private let disposeBag = DisposeBag()
    //    button click variables
    
    private var onViewDidLoad = PublishRelay<Void>()
    
    var viewModel: EventDetailViewModel!
    lazy var viewModelOutput: EventDetailViewModel.Output = {
        let input = EventDetailViewModel.Input(onViewDidLoad: self.onViewDidLoad.asObservable())
        
        return viewModel.transform(input: input)
    }()
    
    let customView = EventDetailView()
    
    
    // MARK: - Lifecycle methods
    
    public init(viewModel: EventDetailViewModel) {
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
        print(viewModelOutput)
        
        setupBinding()
        onViewDidLoad.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarSettings()
    }
    
    private func setupNavigationBarSettings() {
        guard let navController = navigationController else {
            return
        }
        
        navController.setNavigationBarHidden(false, animated: true)
        navController.navigationBar.alpha = 0.1
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.isUserInteractionEnabled = false
        navController.navigationBar.tintColor = UIColor.black
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupBinding() {
        setupViewChangesBindings()
        setupShareBindings()
        setupBackButtonBindings()
    }
    
    private func setupBackButtonBindings() {
        customView
            .backButton
            .rx.tap.subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupShareBindings() {
        customView
            .shareButton
            .rx.tap.subscribe(onNext: { [weak self] _ in
                
                guard let eventValue = self?.viewModel.event.value else {
                    return
                }
                
                let textToShare = [ eventValue.eventDescription ]
                let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self?.view
                
                self?.present(activityViewController, animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
    }
    
    private func setupViewChangesBindings() {
        viewModel
            .event
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                guard let modelValue = model else {
                    return
                }
                self?.changeViewBasedOnEvent(modelValue)
            }).disposed(by: disposeBag)
    }
    
    private func changeViewBasedOnEvent(_ event: WoopEvent) {
        guard let correctURL = URL(string: event.image) else {
            return
        }
        
        customView
            .backgroundImage
            .image = try? UIImage(data: Data(contentsOf: correctURL))
        
        customView
            .titleLabel
            .text = event.title
        
        customView
            .descriptionTextView
            .text = event.eventDescription
        
    }
}

