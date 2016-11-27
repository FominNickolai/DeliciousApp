//
//  DetailImageCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/22/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DetailImageCell: DetailBaseCell {
    
    weak var detailVC: DetailVC?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "food-3")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    
    let activityIndicator: NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activity.type = .ballTrianglePath
        activity.color = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(activityIndicator)
        addSubview(imageView)
        
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        
    }
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if let imageView = tapGesture.view as? UIImageView {
            self.detailVC?.performZoomInForStartindImageView(startingImageView: imageView)
        }
        
    }
}
