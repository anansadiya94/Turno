//
//  UIImageView+Utils.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setThumbnailImageView(from url: String?) {
        if let stringUrl = url, let url = URL(string: stringUrl) {
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result: Result<RetrieveImageResult, KingfisherError>) in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: kDefaultImage)
                    }
                case .success(let imageResult):
                    DispatchQueue.main.async {
                        self?.image = imageResult.image
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.image = UIImage(named: kDefaultImage)
            }
        }
    }
}
