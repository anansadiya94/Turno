//
//  UICollectionView+PresenterOnboarding.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UICollectionViewDataSource
extension PresenterOnboarding: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: OnboardingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kOnboardingCellID,
                                                                                       for: indexPath) as? OnboardingCollectionViewCell {
            cell.setUp(modelOnboarding: modelOnboardingList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelOnboardingList.count
    }
}
