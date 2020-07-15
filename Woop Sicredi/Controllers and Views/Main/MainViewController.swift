//
//  ViewController.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private var didSelectEvent = PublishRelay<Void>()
    private var onViewDidLoad = PublishRelay<Void>()
    
    var viewModel: MainViewModel
    lazy var viewModelOutput: MainViewModel.Output = {
        let input = MainViewModel.Input(onViewDidLoad: self.onViewDidLoad,
                                        didSelectEvent: self.didSelectEvent)
        
        return viewModel.transform(input: input)
    }()
    
    let customView = MainView()
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        view = customView
    }
    
    public init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoaderViewBindings()
        setupTableViewDelegate()
        setupTableViewBindings()
        
        onViewDidLoad.accept(())
    }
    
    private func setupTableViewDelegate() {
        customView
            .eventsTableView
            .delegate = self
    }
    
    private func setupTableViewBindings() {
        setupReloadBinding()
        setupRegisterCells()
        setupTableViewCellBinding()
        setupTableViewCellsTap()
    }
    
    private func setupLoaderViewBindings() {
        
        viewModelOutput
            .shouldAppearLoaderView
            .drive(customView.loaderView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModelOutput
            .shouldAppearLoaderView
            .map{!$0}
            .drive(customView.loaderView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModelOutput
            .shouldAppearLoaderView
            .map{!$0}
            .drive(customView.loaderParentView.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    private func setupTableViewCellsTap() {
        customView
            .eventsTableView.rx
            .modelSelected(WoopEvent.self)
            .map{$0.eventId}
            .map{Int($0)}
            .ignoreNil()
            .bind(to: viewModel.selectedEventId)
            .disposed(by: disposeBag)
        
        customView
            .eventsTableView.rx
            .modelSelected(WoopEvent.self)
            .map{_ in }
            .bind(to: didSelectEvent)
            .disposed(by: disposeBag)
    }
    
    private func setupTableViewCellBinding() {
        viewModel
            .events
            .asObservable()
            .bind(to: customView.eventsTableView.rx.items(cellIdentifier: "MainViewTableViewCell" , cellType: MainViewTableViewCell.self)){ row, item, cell in
                
                cell.selectionStyle = .none
                let viewToAdd = MainTableViewCellLayout(titleLabelText: item.title,
                                                        eventImageURL: item.image)
                cell.config(viewToAdd: viewToAdd)
                
        }.disposed(by: disposeBag)
    }
    
    private func setupReloadBinding() {
        viewModel
            .events
            .subscribe(onNext: { [weak self] _ in
                self?
                    .customView
                    .eventsTableView
                    .reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func setupRegisterCells() {
        customView
            .eventsTableView
            .register(MainViewTableViewCell.self, forCellReuseIdentifier: "MainViewTableViewCell")
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MainTableViewHeader()
    }
}
