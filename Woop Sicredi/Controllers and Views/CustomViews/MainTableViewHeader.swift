//
//  MainTableViewHeader.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 10/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit

class MainTableViewHeader: UITableViewHeaderFooterView {
    
    //MARK: - Variables
    
    static var reusableIdentifier: String = "MainViewTableViewHeader"
    
    let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "woop_logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    // MARK: - Lifecycle methods
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        addSubview(logoImage)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints(){
        setupLogoImageConstraints()
    }
    
    private func setupLogoImageConstraints() {
        
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.5),
            logoImage.topAnchor.constraint(equalTo: topAnchor),
            logoImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    
}
