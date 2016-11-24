//
//  MainCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    var recipe: Recipe? {
        didSet {
            if let title = recipe?.title {
                let shadow = NSShadow()
                shadow.shadowOffset = CGSize(width: 1, height: 1)
                shadow.shadowColor = UIColor.black
                let attributes = [
                    NSShadowAttributeName : shadow,
                    NSForegroundColorAttributeName : UIColor.white,
                    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20)
                ]
                cellTitle.attributedText = NSAttributedString(string: title, attributes: attributes)
            }
            
            if let urlString = recipe?.imageUrl {
                cellImage.loadImageUsingCacheWithUrlString(urlString: urlString)
            }
            
            
        }
    }
    
    let isNew: UILabel = {
        let label = UILabel()
        label.text = "NEW"
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        label.textColor = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "food-3")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(cellImage)
        addSubview(isNew)
        addSubview(blurView)
        blurView.addSubview(cellTitle)
        
        cellImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        cellImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        isNew.widthAnchor.constraint(equalToConstant: 48).isActive = true
        isNew.heightAnchor.constraint(equalToConstant: 26).isActive = true
        isNew.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        isNew.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        blurView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cellTitle.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 10).isActive = true
        cellTitle.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -10).isActive = true
        cellTitle.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
