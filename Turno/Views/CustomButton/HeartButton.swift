//
//  HeartButton.swift
//  Turno
//
//  Created by Anan Sadiya on 27/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class HeartButton: UIButton {
    var isLiked: Bool = false {
        didSet {
            setImage(isLiked ? likedImage : unlikedImage, for: .normal)
        }
    }
    
    private let unlikedImage = UIImage(systemName: "heart")
    private let likedImage = UIImage(systemName: "heart.fill")
    
    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 1.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = .white
        setImage(isLiked ? likedImage : unlikedImage, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tintColor = .white
        setImage(isLiked ? likedImage : unlikedImage, for: .normal)
    }
    
    func flipLikedState() {
        isLiked = !isLiked
        animate()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked ? self.likedImage : self.unlikedImage
            let newScale = self.isLiked ? self.likedScale : self.unlikedScale
            self.transform = self.transform.scaledBy(x: newScale, y: newScale)
            self.setImage(newImage, for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
