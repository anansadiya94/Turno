//
//  UITableView+EmpyMessage.swift
//  Turno
//
//  Created by Anan Sadiya on 04/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UITableView {
    func emptyMessage(title: String, message: String) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: bounds.size.width, height: bounds.size.height))
        let view = UIView(frame: rect)
        let stackView = UIStackView()
        let titleLabel = CustomLabel()
        let messageLabel = CustomLabel()
        
        titleLabel.labelTheme = BoldTheme(label: title, fontSize: 20, textColor: .black, textAlignment: .center)
        messageLabel.labelTheme = RegularTheme(label: message, fontSize: 15, textColor: .black, textAlignment: .center)
        
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
        backgroundView = view
        separatorStyle = .none
    }
    
    func removeEmptyMessage() {
        backgroundView = nil
    }
}
