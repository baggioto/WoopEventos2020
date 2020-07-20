//
//  EventDetailView.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 10/05/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit

class EventDetailView: UIView {
    
    //MARK: - Variables
    
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
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.alpha = 0.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.dataDetectorTypes = []
        textView.font = .systemFont(ofSize: 18)
        return textView
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let btnImage = UIImage(named: "share_button")
        button.setImage(btnImage , for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let btnImage = UIImage(named: "back_button")
        button.setImage(btnImage , for: .normal)
        return button
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let checkinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fazer check-in", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let gradientView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        addSubview(backgroundImage)
        addSubview(titleLabel)
        addSubview(descriptionTextView)
        addSubview(shareButton)
        addSubview(backButton)
        addSubview(loaderParentView)
        loaderParentView.addSubview(loaderView)
        addSubview(footerView)
        footerView.addSubview(checkinButton)
        addSubview(gradientView)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints(){
        setupBackgroundImageConstraints()
        setupTitleLabelConstraints()
        setupDescriptionTextViewConstraints()
        setupShareButtonConstraints()
        setupBackButtonConstraints()
        setupLoaderParentViewConstraints()
        setupLoaderViewConstraints()
        setupGradientViewConstraints()
        setupCheckinButtonConstraints()
        setupFooterViewConstraints()
    }
    
    private func setupCheckinButtonConstraints() {
        NSLayoutConstraint.activate([
            checkinButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 38),
            checkinButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -38),
            checkinButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            checkinButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -20),
            checkinButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupFooterViewConstraints() {
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupGradientViewConstraints() {
        NSLayoutConstraint.activate([
            gradientView.heightAnchor.constraint(equalToConstant: 10),
            gradientView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor)
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
    
    private func setupBackButtonConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupShareButtonConstraints() {
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            shareButton.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            shareButton.heightAnchor.constraint(equalToConstant: 25),
            shareButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupDescriptionTextViewConstraints() {
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 25)
        ])
    }
    
    private func setupBackgroundImageConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: backgroundImage.widthAnchor, multiplier: 0.5)
        ])
    }
    
}
