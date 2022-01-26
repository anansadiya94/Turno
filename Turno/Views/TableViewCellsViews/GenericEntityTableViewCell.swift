//
//  BusinessTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class GenericEntityTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var favoriteButton: HeartButton!
    
    var identifier: String?
    
    // MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }
    
    // MARK: - Private methods
    private func setUpView() {
        baseView.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.5).cgColor, shadowRadius: 5,
                           shadowOffset: CGSize(width: 0.5, height: 1), shadowOpacity: 1)
        baseView.layer.cornerRadius = 5
        titleView.backgroundColor = .primaryAlpha75
        titleView.roundCorners(corners: [.topRight, .topLeft], radius: 5.0)
        thumbnailImage.layer.cornerRadius = 5.0
        thumbnailImage.backgroundColor = UIColor.lightGray
        thumbnailImage.contentMode = .scaleAspectFill
    }
    
    private func setThumbnailImageView(url: String?) {
        thumbnailImage?.setThumbnailImageView(from: url)
    }
    
    // MARK: - Public Interface
    func config(model: ModelBusiness) {
        self.identifier = model.identifier
        setThumbnailImageView(url: model.image)
        titleLabel.labelTheme = BoldTheme(label: model.name ?? "",
                                          fontSize: 25,
                                          textColor: .white,
                                          textAlignment: .center)
        favoriteButton.isLiked = model.isFavorite ?? false
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let button = sender as? HeartButton else { return }
        button.flipLikedState()
        if let identifier = self.identifier {
            let dict: [String: String] = ["identifier": identifier]
            NotificationCenter.default.post(name: GenericEntity.isFavoriteTapped, object: nil,
                                            userInfo: dict)
        }
    }
}
