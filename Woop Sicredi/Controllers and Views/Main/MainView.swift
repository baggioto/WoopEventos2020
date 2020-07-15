//
//  MainView.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 03/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    //MARK: - Variables
    
    let eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    let loaderView: UIActivityIndicatorView = {
        $0.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        $0.color = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView())
    
    let loaderParentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        return $0
    }(UIView())
    
    // MARK: - Lifecycle methods
    
    init() {
        super.init(frame: .zero)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    private func setupView() {
        buildViewHierarchy()
        setupConstraints()
    }
    
    //MARK: - Hierarchy
    
    private func buildViewHierarchy(){
        addSubview(eventsTableView)
        addSubview(loaderParentView)
        loaderParentView.addSubview(loaderView)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints(){
        setupTableViewConstraints()
        setupLoaderParentViewConstraints()
        setupLoaderViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            eventsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            eventsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupLoaderViewConstraints() {
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: loaderParentView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: loaderParentView.centerYAnchor),
            loaderView.heightAnchor.constraint(equalToConstant: 30),
            loaderView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupLoaderParentViewConstraints() {
        NSLayoutConstraint.activate([
            loaderParentView.topAnchor.constraint(equalTo: topAnchor),
            loaderParentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loaderParentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loaderParentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
