//
//  OnBoardingView.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

protocol CustomPageControlDataSource: AnyObject {
    func numberOfPages() -> Int
}

class OnBoardingView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var pageControl = UIPageControl(frame: .zero)
    private var collectionViewFlowLayout: UICollectionViewFlowLayout?
    var collectionView: UICollectionView?
    
    weak var pageControlDataSource: CustomPageControlDataSource? {
        didSet {
            pageControl.numberOfPages = pageControlDataSource!.numberOfPages()
        }
    }
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCollectionView()
        setupPageControl()
        registerNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func registerNib() {
        self.collectionView?.register(UINib(nibName: kOnboardingCollectionViewCellNib, bundle: nil), forCellWithReuseIdentifier: kOnboardingCellID)
    }
    
    private func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = .primary
        pageControl.pageIndicatorTintColor = .primaryAlpha20
        pageControl.isEnabled = false
        
        self.insertSubview(pageControl, at: 0)
        self.bringSubviewToFront(pageControl)
        setPageControlConstraints()
    }
    
    private func setPageControlConstraints() {
        NSLayoutConstraint.activate([
            pageControl.leftAnchor.constraint(equalTo: self.leftAnchor),
            pageControl.rightAnchor.constraint(equalTo: self.rightAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createCollectionView() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        guard let layout = collectionViewFlowLayout else { return }
        
        collectionViewFlowLayout?.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kOnboardingCellID)
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        
        (collectionView != nil) ? self.addSubview(collectionView!) : assertionFailure(kNilCollectionView)
    }
    
    // MARK: - Public Interface
    func setCurrentPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}
