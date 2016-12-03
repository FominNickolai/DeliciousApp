//
//  AddTitleCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/23/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class AddTitleCell: DetailBaseCell {
    
    weak var addVC: AddVC? {
        didSet {
            timeToCook.addTarget(addVC, action: #selector(addVC?.textChanged), for: .editingChanged)
            personCount.addTarget(addVC, action: #selector(addVC?.textChanged), for: .editingChanged)
            cellTitle.addTarget(addVC, action: #selector(addVC?.textChanged), for: .editingChanged)
        }
    }
    
    let clockImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Clock")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let timeToCook: UITextField = {
        let textField = UITextField()
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        textField.attributedPlaceholder = NSAttributedString(string: "Time cook...", attributes: attributes)
        textField.textColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.leftView = paddingView
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let forkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Fork")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let personCount: UITextField = {
        let textField = UITextField()
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        textField.attributedPlaceholder = NSAttributedString(string: "Person count...", attributes: attributes)
        textField.textColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.leftView = paddingView
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let cellTitle: UITextField = {
        let textField = UITextField()
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        textField.attributedPlaceholder = NSAttributedString(string: "Recipe title...", attributes: attributes)
        textField.textColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.leftView = paddingView
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        
        addSubview(cellTitle)
        addSubview(clockImage)
        addSubview(timeToCook)
        addSubview(forkImage)
        addSubview(personCount)
        
        cellTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        cellTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        cellTitle.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        cellTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        clockImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        clockImage.topAnchor.constraint(equalTo: cellTitle.bottomAnchor, constant: 15).isActive = true
        clockImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
        clockImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
        timeToCook.leftAnchor.constraint(equalTo: clockImage.rightAnchor, constant: 10).isActive = true
        timeToCook.centerYAnchor.constraint(equalTo: clockImage.centerYAnchor).isActive = true
        timeToCook.heightAnchor.constraint(equalToConstant: 30).isActive = true
        timeToCook.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35)
.isActive = true
        personCount.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        personCount.centerYAnchor.constraint(equalTo: clockImage.centerYAnchor).isActive = true
        personCount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        personCount.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35).isActive = true
        forkImage.rightAnchor.constraint(equalTo: personCount.leftAnchor, constant: -10).isActive = true
        forkImage.centerYAnchor.constraint(equalTo: clockImage.centerYAnchor).isActive = true
    }
}
