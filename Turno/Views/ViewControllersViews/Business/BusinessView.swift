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
    @UseAutoLayout var segmentedControl = UISegmentedControl(items: ["Services", "My turns", "Information"])
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        createImageView()
        createSegmentedControl()
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
        segmentedControl.selectedSegmentIndex = 0
        addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            segmentedControl.leftAnchor.constraint(equalTo: leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    // MARK: - Public Interface
    func setImage(image: String?) {
        imageView.setThumbnailImageView(from: image)
    }
}
