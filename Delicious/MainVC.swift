//
//  MainVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import BetterSegmentedControl

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
    
    let segmentedControl: BetterSegmentedControl = {
        let segmented = BetterSegmentedControl()
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.titles = ["ALL","NEW","TRENDING"]
        segmented.titleFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        segmented.selectedTitleFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        segmented.titleColor = UIColor.white
        segmented.backgroundColor = UIColor(red:0.341,  green:0.290,  blue:0.298, alpha:1)
        segmented.indicatorViewBackgroundColor = UIColor(red:0.996,  green:0.306,  blue:0.314, alpha:1)
        segmented.cornerRadius = 5.0
        segmented.alwaysAnnouncesValue = true
        return segmented
    }()
    
    let menuTransitionManager = MenuTransitionManager()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Delicious"
        navigationItem.leftBarButtonItem = menuNavBarButton
        navigationItem.rightBarButtonItem = logOutBarButton
        collectionView?.register(MainCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .red
        view.addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    deinit {
        print("MainVC Deinit")
    }
    
}
//Actions
extension MainVC {
    func handleMenuButtonPressed() {
        print("Menu Pressed")
        let menuVC = MenuVC()
        
        menuVC.transitioningDelegate = menuTransitionManager
        menuTransitionManager.delegate = self
        present(menuVC, animated: true, completion: nil)
    }
    
    func handleLogOutButton() {
        print("Log Out Pressed")
         _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        dismiss(animated: true, completion: nil)
    }
}

extension MainVC: MenuTransitionManagerDelegate {
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}
//UICollectionViewDataSource
extension MainVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainCell
        return cell
        
    }
}

//UICollectionViewDelegate
extension MainVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailVC()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

//UICollectionViewDelegateFlowLayout
extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 244)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(8, 0, 0, 0)
        
    }
    
}
