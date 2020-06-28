//
//  BusinessTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Kingfisher

class GenericEntityTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var favoriteButton: HeartButton!
    
    var identifier: String? = ""
    
    // MARK: - UICollectionViewCell
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
        baseView.layer.cornerRadius = 5.0
        titleView.backgroundColor = .primaryAlpha75
        titleView.roundCorners(corners: [.topRight, .topLeft], radius: 5.0)
        thumbnailImage.layer.cornerRadius = 5.0
        thumbnailImage.backgroundColor = UIColor.lightGray
        thumbnailImage.contentMode = .scaleAspectFill
    }
    
    private func setThumbnailImageView(url: String?) {
        if let stringUrl = url, let url = URL(string: stringUrl) {
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result: Result<RetrieveImageResult, KingfisherError>) in
                switch result {
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    //TODO set default image
                case .success(let imageResult):
                    DispatchQueue.main.async {
                        self?.thumbnailImage.image = imageResult.image
                    }
                }
            }
        } else {
            //TODO set default image
        }
        
    }
    
    // MARK: - Public Interface
    func config(model: ModelBusiness) {
        self.identifier = model.identifier
        setThumbnailImageView(url: model.image)
        titleLabel.labelTheme = BoldTheme(label: model.name ?? "",
                                          fontSize: 30,
                                          textColor: .white,
                                          textAlignment: .center)
        favoriteButton.isLiked = true
    }
    
    func didSelect(model: ModelBusiness) {
        //TODO
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let button = sender as? HeartButton else { return }
        button.flipLikedState()
        //TODO modify model and call API
    }
}
