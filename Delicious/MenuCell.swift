//
//  MenuCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    var menuItem: String? {
        didSet {
            self.textLabel?.text = menuItem
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.textLabel?.textColor = .white
        self.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
