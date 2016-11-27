//
//  PaddingLabel.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/27/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        
    }
    
}
