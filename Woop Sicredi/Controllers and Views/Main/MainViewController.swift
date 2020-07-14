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
    
    private let disposeBag = DisposeBag()
    
    private var onViewDidLoad = PublishRelay<Void>()
    
    var viewModel = MainViewModel()
    lazy var viewModelOutput: MainViewModel.Output = {
        let input = MainViewModel.Input(onViewDidLoad: self.onViewDidLoad.asObservable())
        
        return viewModel.transform(input: input)
    }()
    
    let customView = MainView()
    
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        view = customView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(viewModelOutput)
        
        setupTableViewBindings()
        setupTableViewDelegate()

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
    
    private func setupTableViewCellsTap() {
        customView
        .eventsTableView
        .rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            
            guard let eventIdString = self?.viewModel.events.value[indexPath.row].eventId else {
                return
            }
            
            guard let eventId = Int(eventIdString) else {
                return
            }
            
            let model = EventDetailViewModel(eventId: Int(eventId))
            let vc = EventDetailViewController(viewModel: model)
            self?.navigationController?.pushViewController(vc, animated: false)
            
        }).disposed(by: disposeBag)
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
