//
//  AddImageCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/23/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
class AddImageCell: DetailBaseCell {
    
    weak var addVC: AddVC? {
        didSet{
            addButtonImage.addGestureRecognizer(UITapGestureRecognizer(target: addVC, action: #selector(addVC?.handleUploadTap)))
        }
    }
    
    var setImage: UIImage? {
        didSet {
            uploadImageView.image = setImage!
            addButtonImage.alpha = 0.2
        }
    }
    
    let addButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "image-add-button")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        
        addSubview(uploadImageView)
        addSubview(addButtonImage)
        
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        uploadImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        uploadImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        addButtonImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        addButtonImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        addButtonImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addButtonImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
