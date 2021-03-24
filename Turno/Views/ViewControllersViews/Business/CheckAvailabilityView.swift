//
//  CheckAvailabilityView.swift
//  Turno
//
//  Created by Anan Sadiya on 06/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class CheckAvailabilityView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var totalServicesTimeLabel = CustomLabel()
    var daysCollectionView: UICollectionView?
    var hoursCollectionView: UICollectionView?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout?
    @UseAutoLayout var bookNowButton = RoundedCustomButton()
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBookNowButton()
        createTotalServicesTimeLabel()
        createDaysCollectionView()
        createHoursCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    func createBookNowButton() {
        addSubview(bookNowButton)
        bookNowButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.book_now_key.localized)
        setBookNowButton(to: false)
        
        NSLayoutConstraint.activate([
            bookNowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            bookNowButton.heightAnchor.constraint(equalToConstant: 44.0),
            bookNowButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 32.0),
            bookNowButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.0)
        ])
    }
    
    private func createTotalServicesTimeLabel() {
        addSubview(totalServicesTimeLabel)
        totalServicesTimeLabel.labelTheme = SemiBoldTheme(label: "", fontSize: 20, textColor: .black, textAlignment: .natural)
        
        NSLayoutConstraint.activate([
            totalServicesTimeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            totalServicesTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0),
            totalServicesTimeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0)
        ])
    }
    
    private func createDaysCollectionView() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        guard let layout = collectionViewFlowLayout else { return }
        layout.scrollDirection = .horizontal
        
        daysCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        daysCollectionView?.backgroundColor = .white
        daysCollectionView?.showsHorizontalScrollIndicator = false
        
        guard let daysCollectionView = daysCollectionView else { return }
        addSubview(daysCollectionView)
        
        daysCollectionView.translatesAutoresizingMaskIntoConstraints = false
        daysCollectionView.topAnchor.constraint(equalTo: totalServicesTimeLabel.bottomAnchor, constant: 8.0).isActive = true
        daysCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        daysCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
        daysCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
    }
    
    private func createHoursCollectionView() {
        hoursCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: UICollectionViewFlowLayout())
        hoursCollectionView?.backgroundColor = .white
        hoursCollectionView?.showsVerticalScrollIndicator = false
        
        guard let hoursCollectionView = hoursCollectionView, let daysCollectionView = daysCollectionView else { return }
        addSubview(hoursCollectionView)
        
        hoursCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hoursCollectionView.topAnchor.constraint(equalTo: daysCollectionView.bottomAnchor, constant: 8.0).isActive = true
        hoursCollectionView.bottomAnchor.constraint(equalTo: bookNowButton.topAnchor, constant: -8.0).isActive = true
        hoursCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8.0).isActive = true
        hoursCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true
    }
    
    // MARK: - Public Interface
    func setTotalServicesTimeLabel(to time: String) {
        totalServicesTimeLabel.text = String(format: LocalizedConstants.total_services_time_key.localized, time)
    }
    
    func setBookNowButton(to enabled: Bool) {
        bookNowButton.isEnabled = enabled
        bookNowButton.backgroundColor = enabled ? .primary : UIColor.primary.withAlphaComponent(0.5)
    }
}
