//
//  BusinessView.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var imageView = UIImageView()
    @UseAutoLayout var segmentedControl = UISegmentedControl(items: [LocalizedConstants.services_key.localized,
                                                                     LocalizedConstants.my_turns_key.localized,
                                                                     LocalizedConstants.information_key.localized])
    @UseAutoLayout var tableView = UITableView()
    @UseAutoLayout var checkAvailabilityButton = RoundedCustomButton()
    
    var checkAvailabilityButtonViewHeight = NSLayoutConstraint()
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        createImageView()
        createSegmentedControl()
        createCheckAvailabilityButton()
        createTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func createImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
    }
    
    private func createSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            segmentedControl.leftAnchor.constraint(equalTo: leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func createCheckAvailabilityButton() {
        addSubview(checkAvailabilityButton)
        checkAvailabilityButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.check_availability_key.localized)
        setCheckAvailabilityButton(0)
        checkAvailabilityButtonViewHeight = checkAvailabilityButton.heightAnchor.constraint(equalToConstant: 44.0)
        
        NSLayoutConstraint.activate([
            checkAvailabilityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            checkAvailabilityButtonViewHeight,
            checkAvailabilityButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 32.0),
            checkAvailabilityButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.0)
        ])
    }
    
    private func createTableView() {
        addSubview(tableView)
        tableView.alwaysBounceVertical = true
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: checkAvailabilityButton.topAnchor),
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    // MARK: - Public Interface
    func setCheckAvailabilityButton(_ count: Int) {
        checkAvailabilityButton.isEnabled = count >= 1 ? true : false
        checkAvailabilityButton.backgroundColor = count >= 1 ? .primary : UIColor.primary.withAlphaComponent(0.5)
    }
    
    func setView() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            checkAvailabilityButton.isHidden = false
            checkAvailabilityButtonViewHeight.constant = 44.0
        default:
            checkAvailabilityButton.isHidden = true
            checkAvailabilityButtonViewHeight.constant = 0.0
        }
    }
    
    func setImage(image: String?) {
        imageView.setThumbnailImageView(from: image)
    }
}
