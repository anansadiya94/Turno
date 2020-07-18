//
//  CustomLabel.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    var labelTheme: CustomLabelTheme? {
        didSet {
            setupStyle()
        }
    }
    
    private func setupStyle() {
        if let labelTheme = labelTheme {
            text = labelTheme.label
            textColor = labelTheme.textColor
            font = labelTheme.font
            textAlignment = labelTheme.textAlignment
            numberOfLines = labelTheme.numberOfLines
            adjustsFontSizeToFitWidth = labelTheme.adjustsFontSizeToFitWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
    }
}
