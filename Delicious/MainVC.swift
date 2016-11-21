//
//  MainVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MainVC: UICollectionViewController {
    
    lazy var menuNavBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: .plain, target: self, action: #selector(handleMenuButtonPressed))
        button.tintColor = .white
        return button
    }()
    
    lazy var logOutBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(handleLogOutButton))
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Delicious"
        navigationItem.leftBarButtonItem = menuNavBarButton
        navigationItem.rightBarButtonItem = logOutBarButton
        collectionView?.backgroundColor = .blue
    }
    
    deinit {
        print("MainVC Deinit")
    }
    
}
//Actions
extension MainVC {
    func handleMenuButtonPressed() {
        print("Menu Pressed")
    }
    
    func handleLogOutButton() {
        print("Log Out Pressed")
         _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        dismiss(animated: true, completion: nil)
    }
}
