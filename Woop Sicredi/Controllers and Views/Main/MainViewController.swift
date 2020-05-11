//
//  ViewController.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit
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
        setupTableViewDelegates()
        
        onViewDidLoad.accept(())
        
    }
    
    private func setupTableViewDelegates() {
        
        customView
            .eventsTableView
            .delegate = self
        
        customView
            .eventsTableView
            .dataSource = self
        
    }
    
    private func setupTableViewBindings() {
        
        setupReloadBinding()
        setupRegisterCells()
        
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

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let eventId = Int(viewModel.events.value[indexPath.row].eventId) else {
            return
        }
        
        let model = EventDetailViewModel(eventId: eventId)
        let vc = EventDetailViewController(viewModel: model)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MainViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainViewTableViewCell") as! MainViewTableViewCell
        cell.selectionStyle = .none
        
        let viewToAdd = MainTableViewCellLayout(titleLabelText: viewModel.events.value[indexPath.row].title,
                                                eventImageURL: viewModel.events.value[indexPath.row].image)
        
        cell.config(viewToAdd: viewToAdd)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MainTableViewHeader()
    }
    
}

extension MainViewController: UITableViewDelegate {
    
}

