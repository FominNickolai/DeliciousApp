//
//  DetailButtonsCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/22/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class DetailButtonsCell: DetailBaseCell {
    
    let clockImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Clock")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let timeToCook: UILabel = {
        let label = UILabel()
        label.text = "14 mins"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let forkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Fork")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let personCount: UILabel = {
        let label = UILabel()
        label.text = "1 - 2"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Instructions", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let ingridientsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Ingridients", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(red:0.604,  green:0.545,  blue:0.541, alpha:1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let isFavoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "Favorite"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        addSubview(clockImage)
        addSubview(timeToCook)
        addSubview(forkImage)
        addSubview(personCount)
        addSubview(isFavoriteButton)
        
        
        clockImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        clockImage.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        clockImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
        clockImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        timeToCook.leftAnchor.constraint(equalTo: clockImage.rightAnchor, constant: 20).isActive = true
        timeToCook.centerYAnchor.constraint(equalTo: clockImage.centerYAnchor).isActive = true
        
        forkImage.leftAnchor.constraint(equalTo: timeToCook.rightAnchor, constant: 20).isActive = true
        forkImage.centerYAnchor.constraint(equalTo: timeToCook.centerYAnchor).isActive = true
        
        personCount.leftAnchor.constraint(equalTo: forkImage.rightAnchor, constant: 10).isActive = true
        personCount.centerYAnchor.constraint(equalTo: forkImage.centerYAnchor).isActive = true
        
        isFavoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        isFavoriteButton.centerYAnchor.constraint(equalTo: personCount.centerYAnchor).isActive = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.addArrangedSubview(instructionsButton)
        stackView.addArrangedSubview(ingridientsButton)
        
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        instructionsButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        ingridientsButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        
    }
}



















