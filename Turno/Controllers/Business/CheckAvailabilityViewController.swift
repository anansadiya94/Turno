//
//  CheckAvailabilityViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 06/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class CheckAvailabilityViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterCheckAvailability: PresenterCheckAvailability!
    @UseAutoLayout var checkAvailabilityView = CheckAvailabilityView()
    
    var modelCheckTurnsAvailability: ModelCheckTurnsAvailability?
    var modelAvailableTurnDay: [ModelAvailableTurnDay] = []
    var emptySlots: [EmptySlot] = []
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setCheckAvailabilityViewConstraints()
        setCollectionsView()
        addTarget()
    }
    
    // MARK: - Private methods
    private func setCheckAvailabilityViewConstraints() {
        self.view.addSubview(checkAvailabilityView)
        NSLayoutConstraint.activate([
            checkAvailabilityView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            checkAvailabilityView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            checkAvailabilityView.leftAnchor.constraint(equalTo: view.leftAnchor),
            checkAvailabilityView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setCollectionsView() {
        checkAvailabilityView.daysCollectionView?.dataSource = self
        checkAvailabilityView.daysCollectionView?.delegate = self
        checkAvailabilityView.daysCollectionView?.register(UINib(nibName: kAvailableTurnDayCollectionViewCellNib, bundle: nil),
                                                           forCellWithReuseIdentifier: kAvailableTurnDayCellID)
        checkAvailabilityView.hoursCollectionView?.dataSource = self
        checkAvailabilityView.hoursCollectionView?.delegate = self
        checkAvailabilityView.hoursCollectionView?.register(UINib(nibName: kAvailableTurnHourCollectionViewCellCellNib, bundle: nil),
                                                            forCellWithReuseIdentifier: kAvailableTurnHourCellID)
    }
    
    private func addTarget() {
        checkAvailabilityView.bookNowButton.addTarget(self, action: #selector(bookNowButtonTapped), for: .touchUpInside)
    }
    
    private func mapEmptySlots(from availableDates: [String: [Date]], forKey key: String) {
        emptySlots = []
        if let emptySlots = availableDates[key] {
            emptySlots.forEach({ self.emptySlots.append(EmptySlot(slot: $0, selected: false)) })
        }
    }
    
    // MARK: - UI interaction methods
    @objc func bookNowButtonTapped() {
        let bookedSlot = emptySlots.first(where: { $0.selected == true })
        presenterCheckAvailability.bookNowButtonTapped(bookedSlot: bookedSlot)
    }
}

// MARK: - PresenterCheckAvailabilityView methods
extension CheckAvailabilityViewController: PresenterCheckAvailabilityView {
    func didSetData(name: String?, modelCheckTurnsAvailability: ModelCheckTurnsAvailability, totalServicesTime: String) {
        self.modelCheckTurnsAvailability = modelCheckTurnsAvailability
        if let availableDates = modelCheckTurnsAvailability.availableDates {
            availableDates.forEach({
                self.modelAvailableTurnDay.append(ModelAvailableTurnDay(date: $0.key,
                                                                        selected: false))
            })
            modelAvailableTurnDay.sort { $0.date ?? "" < $1.date ?? "" }
            modelAvailableTurnDay[0].selected = true
            if let firstKey = modelAvailableTurnDay[0].date {
                mapEmptySlots(from: availableDates, forKey: firstKey)
            }
        }
        DispatchQueue.main.async {
            self.navigationItem.title = name
            self.checkAvailabilityView.setTotalServicesTimeLabel(to: totalServicesTime)
            self.checkAvailabilityView.daysCollectionView?.reloadData()
            self.checkAvailabilityView.hoursCollectionView?.reloadData()
        }
    }
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
}

// MARK: - UICollectionViewDataSource methods
extension CheckAvailabilityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == checkAvailabilityView.daysCollectionView {
            return modelAvailableTurnDay.count
        } else if collectionView == checkAvailabilityView.hoursCollectionView {
            return emptySlots.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == checkAvailabilityView.daysCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAvailableTurnDayCellID,
                                                             for: indexPath) as? AvailableTurnDayCollectionViewCell {
                cell.config(modelAvailableTurnDay: modelAvailableTurnDay[indexPath.row])
                return cell
            }
        } else if collectionView == checkAvailabilityView.hoursCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAvailableTurnHourCellID,
                                                             for: indexPath) as? AvailableTurnHourCollectionViewCell {
                cell.config(emptySlot: emptySlots[indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate methods
extension CheckAvailabilityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == checkAvailabilityView.daysCollectionView {
            modelAvailableTurnDay.filter({ $0.selected == true }).first?.selected = false
            modelAvailableTurnDay[indexPath.row].selected = true
            emptySlots.forEach({ $0.selected = false })
            if let availableDates = modelCheckTurnsAvailability?.availableDates,
                let key = modelAvailableTurnDay[indexPath.row].date {
                mapEmptySlots(from: availableDates, forKey: key)
            }
            checkAvailabilityView.setBookNowButton(to: false)
            checkAvailabilityView.daysCollectionView?.reloadData()
            checkAvailabilityView.hoursCollectionView?.reloadData()
        } else if collectionView == checkAvailabilityView.hoursCollectionView {
            emptySlots.filter({ $0.selected == true }).first?.selected = false
            emptySlots[indexPath.row].selected = true
            checkAvailabilityView.setBookNowButton(to: true)
            checkAvailabilityView.hoursCollectionView?.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods
extension CheckAvailabilityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == checkAvailabilityView.daysCollectionView {
            return  CGSize(width: 120, height: 100)
        } else if collectionView == checkAvailabilityView.hoursCollectionView {
            return CGSize(width: (view.frame.width - 16) / 3, height: 50)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
