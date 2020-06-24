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
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabel!
    
    var identifier: String? = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setUpView()
    }
    
    private func setUpView() {
        thumbnailImage.backgroundColor = UIColor.lightGray
        thumbnailImage.contentMode = .scaleAspectFill
    }
    
    private func setThumbnailImageView(url: String) {
        guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.thumbnailImage.image = image
            }
        }
    }
    
    // MARK: - Public Interface
    func config(model: ModelBusiness) {
        self.identifier = model.identifier
        setThumbnailImageView(url: model.image ?? "")
        titleLabel.labelTheme = BoldTheme(label: model.name ?? "",
                                          fontSize: 15,
                                          textColor: .black,
                                          textAlignment: .left,
                                          numberOfLines: 2,
                                          adjustsFontSizeToFitWidth: true)
    }
    
    func didSelect(model: ModelBusiness) {
        //TODO
    }
}
