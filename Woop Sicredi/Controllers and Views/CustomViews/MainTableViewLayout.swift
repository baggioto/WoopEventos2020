//
//  MainTableViewLayout.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 10/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit

class MainTableViewCellLayout: UIView {
    
    //MARK: - Variables
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // MARK: - Lifecycle methods
    
    init(titleLabelText: String, eventImageURL: String) {
        super.init(frame: .zero)
        
        titleLabel.text = titleLabelText
        
        guard let correctURL = URL(string: eventImageURL) else {
            return
        }
        
        imageView.image = try? UIImage(data: Data(contentsOf: correctURL))
        
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
        addSubview(titleLabel)
        addSubview(imageView)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints(){
        setupTitleLabelConstraints()
        setupImageViewConstraints()
    }
    
    private func setupImageViewConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
    }
    
    private func setupTitleLabelConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    
    
}