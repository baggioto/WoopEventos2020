//
//  MainViewTableViewCell.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 10/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit
import Foundation
import RxDataSources

class MainViewTableViewCell: UITableViewCell {
    
    var centralView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.centralView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    public func config(viewToAdd: UIView) {
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        self.centralView.addSubview(viewToAdd)
        setupCustomViewConstraints(customView: viewToAdd)
    }
    
    private func buildHierarchy() {
        contentView.addSubview(self.centralView)
    }
    
    private func setupConstraints() {
        setupCentralViewConstraints()
    }
    
    private func setupCustomViewConstraints(customView: UIView) {
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: self.centralView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: self.centralView.trailingAnchor),
            customView.topAnchor.constraint(equalTo: self.centralView.topAnchor),
            customView.bottomAnchor.constraint(equalTo: self.centralView.bottomAnchor)
        ])
    }
    
    private func setupCentralViewConstraints() {
        NSLayoutConstraint.activate([
            centralView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            centralView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            centralView.topAnchor.constraint(equalTo: contentView.topAnchor),
            centralView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
}

