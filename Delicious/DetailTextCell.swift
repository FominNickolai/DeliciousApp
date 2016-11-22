//
//  DetialTextCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/22/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class DetailTextCell: DetailBaseCell {
    
    let messageTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        tv.text = "1. Blend the ingredients for pesto in a processor and keep aside."
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        return tv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundView = blurEffectView
        
        addSubview(messageTextView)
        
        messageTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }
    
}
