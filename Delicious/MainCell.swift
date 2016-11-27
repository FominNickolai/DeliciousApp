//
//  MainCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

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
            
            if let urlString = recipe?.recipeImage {
                self.activityIndicator.startAnimating()
                cellImage.loadImageUsingCacheWithUrlString(urlString: urlString, completion: {
                
                    self.activityIndicator.stopAnimating()
                    
                })
            }
            
            if let likesArray = recipe?.likedPosts {
                let countLikes = likesArray.count
                likesCountLabel.text = String(countLikes)
            }
        }
    }
    
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
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    let favoriteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "active_heart")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activity.type = .ballTrianglePath
        activity.color = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        activity.stopAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(cellImage)
        addSubview(blurView)
        addSubview(activityIndicator)
        blurView.addSubview(cellTitle)
        blurView.addSubview(favoriteImage)
        blurView.addSubview(likesCountLabel)
        
        
        cellImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        cellImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        blurView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteImage.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -10).isActive = true
        favoriteImage.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        favoriteImage.widthAnchor.constraint(equalToConstant: 21).isActive = true
        favoriteImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        likesCountLabel.rightAnchor.constraint(equalTo: favoriteImage.leftAnchor, constant: -5).isActive = true
        likesCountLabel.centerYAnchor.constraint(equalTo: favoriteImage.centerYAnchor).isActive = true
        likesCountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        cellTitle.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 10).isActive = true
        cellTitle.rightAnchor.constraint(equalTo: likesCountLabel.leftAnchor, constant: -10).isActive = true
        cellTitle.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.stopAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
