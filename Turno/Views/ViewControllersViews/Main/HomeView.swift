//
//  HomeView.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var tableView =  UITableView()
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func createTableView() {
        addSubview(tableView)

        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
     }
}
