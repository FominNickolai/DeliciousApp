//
//  PageCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/28/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
            
            guard  let page = page else {
                return
            }
            
            var imageName = page.imageName
            //replace image if lanscape
            if UIDevice.current.orientation.isLandscape {
                imageName += "_landscape"
            }
            
            imageView.image = UIImage(named: imageName)
            let color = UIColor(white: 0.2, alpha: 1)
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: color]))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let length = attributedText.string.characters.count
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.image = UIImage(named: "page1")
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeparatorView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        lineSeparatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lineSeparatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lineSeparatorView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
