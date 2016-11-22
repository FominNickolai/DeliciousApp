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

class MainVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 70)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "food-3")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        view.addSubview(imageView)
        view.addSubview(blurView)
        view.addSubview(collectionView)
        
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        view.addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 74).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = "Delicious"
        navigationItem.leftBarButtonItem = menuNavBarButton
        navigationItem.rightBarButtonItem = logOutBarButton
        
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .clear
        
        
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
extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainCell
        return cell
        
    }
}

//UICollectionViewDelegate
extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
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
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    
}