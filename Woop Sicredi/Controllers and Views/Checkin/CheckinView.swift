//
//  CheckinView.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 20/07/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit

class CheckinView: UIView {
    
    //MARK: - Variables
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.minimumFontSize = 20
        textField.placeholder = "Nome"
        textField.textColor = .lightGray
        return textField
    }()
    
    let nameIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.minimumFontSize = 20
        textField.placeholder = "E-mail"
        textField.textColor = .lightGray
        return textField
    }()
    
    let emailIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let checkinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Finalizar check-in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.lightGray, for: .disabled)
        button.setBackgroundColor(.darkGray, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle methods
    
    required init() {
        super.init(frame: .zero)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
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
        addSubview(nameTextField)
        addSubview(nameIndicatorView)
        addSubview(emailTextField)
        addSubview(emailIndicatorView)
        addSubview(checkinButton)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints(){
        setupTitleLabelConstraints()
        setupNameLabelConstraints()
        setupEmailLabelConstraints()
        setupNameIndicatorViewConstraints()
        setupEmailIndicatorViewConstraints()
        setupCheckinButtonConstraints()
    }
    
    private func setupCheckinButtonConstraints() {
        NSLayoutConstraint.activate([
            checkinButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            checkinButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            checkinButton.topAnchor.constraint(equalTo: emailIndicatorView.bottomAnchor, constant: 35),
            checkinButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupNameIndicatorViewConstraints() {
        NSLayoutConstraint.activate([
            nameIndicatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameIndicatorView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            nameIndicatorView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            nameIndicatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupEmailIndicatorViewConstraints() {
        NSLayoutConstraint.activate([
            emailIndicatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailIndicatorView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailIndicatorView.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            emailIndicatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupEmailLabelConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 35),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25),
        ])
    }
    
}
