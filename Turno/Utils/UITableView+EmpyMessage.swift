//
//  UITableView+EmpyMessage.swift
//  Turno
//
//  Created by Anan Sadiya on 04/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UITableView {
    func emptyMessage(_ message: String) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: bounds.size.width, height: bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.alpha = 0.5
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: ServiceAppFont.regularFont, size: 15) ?? .systemFont(ofSize: 15)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
        separatorStyle = .none
    }
    
    func removeEmptyMessage() {
        backgroundView = nil
    }
}
