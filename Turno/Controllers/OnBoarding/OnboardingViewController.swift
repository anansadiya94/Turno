//
//  OnboardingViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
        
    // MARK: - Properties
    var presenterOnboarding: PresenterOnboarding!
    var onBoardingView = OnBoardingView(frame: UIScreen.main.bounds)
        
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setOnBoardingView()
        addObserver()
    }
    
    // MARK: - Private methods
    private func setOnBoardingView() {
        self.view = onBoardingView
        onBoardingView.collectionView?.dataSource = presenterOnboarding
        onBoardingView.collectionView?.delegate = self
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(buttonCellTappedAction(_:)),
                                               name: OnBoarding.onBoardingButtonCellTapped, object: nil)
    }
       
    // MARK: - UI interaction methods
    @objc func buttonCellTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let amILast = dict["amILast"] as? Bool {
                presenterOnboarding.buttonCellTappedAction(amILast: amILast)
            }
        }
    }
}

// MARK: - PresenterOnboardingDelegate methods
extension OnboardingViewController: PresenterOnboardingView {
    func didSetData() {
        onBoardingView.collectionView?.reloadData()
    }
    
    func setPages(num: Int) {
        onBoardingView.pageControl.numberOfPages = num
    }
    
    func nextCell() {
        guard let indexPath = onBoardingView.collectionView?.indexPathsForVisibleItems.first else { return }
        let nextIndexPath: NSIndexPath = NSIndexPath(row: indexPath.row + 1, section: indexPath.section)
        onBoardingView.collectionView?.selectItem(at: nextIndexPath as IndexPath, animated: true,
                                                  scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
    }
}
