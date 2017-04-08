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
import Firebase
import NVActivityIndicatorView

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
    
    lazy var segmentedControl: BetterSegmentedControl = {
        let segmented = BetterSegmentedControl()
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.titles = ["ALL","MY","TRENDING"]
        segmented.titleFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        segmented.selectedTitleFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        segmented.titleColor = UIColor.white
        segmented.backgroundColor = UIColor(red:0.341,  green:0.290,  blue:0.298, alpha:1)
        segmented.indicatorViewBackgroundColor = UIColor(red:0.996,  green:0.306,  blue:0.314, alpha:1)
        segmented.cornerRadius = 5.0
        segmented.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmented.alwaysAnnouncesValue = true
        return segmented
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activity.type = .ballTrianglePath
        activity.color = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    let menuTransitionManager = MenuTransitionManager()
    
    let cellId = "cellId"
    
    var viewDidAppearProcessed = false
    
    var recipes = [Recipe]()
    
    var user: User?
    
    var shownIndexPath = Set<Int>()
    
    var currentFilterItem = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let key = KeychainWrapper.standard.string(forKey: KEY_UID)
        if key == nil && viewDidAppearProcessed == true {
            dismiss(animated: true, completion: nil)
        }
        
        viewDidAppearProcessed = true
        
        do {
            try segmentedControl.set(index: UInt(currentFilterItem), animated: true)
        } catch {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(blurView)
        view.addSubview(activityIndicator)
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
        
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = "Delicious"
        navigationItem.leftBarButtonItem = menuNavBarButton
        
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .clear
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleMenuButtonPressed))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + .seconds(2)) { [unowned self] in
            self.fetchUserData(completion: { 
                self.fetchAllRecipes()
            })
            
        }
        
        do {
            try segmentedControl.set(index: 0, animated: true)
            currentFilterItem = 0
        } catch {
        }
        
        
    }
    
    deinit {
    }
    
}
//MARK: Actions
extension MainVC {
    func handleMenuButtonPressed() {
        let menuVC = MenuVC()
        
        menuVC.transitioningDelegate = menuTransitionManager
        menuVC.mainVC = self
        menuTransitionManager.delegate = self
        present(menuVC, animated: true, completion: nil)
    }
    
    func handleLogOutButton() {
        dismiss(animated: true, completion: nil)
         _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
    }
    
    func showAddVC() {
        dismiss(animated: true, completion: nil)
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        let addVC = AddVC()
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
        case 0:
            fetchAllRecipes()
            currentFilterItem = 0
        case 1:
            fetchByUserRecipes()
            currentFilterItem = 1
        case 2:
            fetchByLikesRecipes()
            currentFilterItem = 2
        default:
            break
        }
    }
    
    func fetchAllRecipes() {
        
        fetchRecipes(byChild: "timestamp", completion: {
            self.recipes.sort { $0.timestamp > $1.timestamp }
        })
    }
    
    func fetchByUserRecipes() {
        
        fetchUserRecipes(byChild: "fromId", completion: {
            self.recipes.sort { $0.timestamp > $1.timestamp }
        })
    }
    
    func fetchByLikesRecipes() {
        
        fetchRecipes(byChild: "likedPosts", completion: {
            self.recipes.sort { $0.likedPosts.count > $1.likedPosts.count }
        })
    }
    
    func fetchRecipes(byChild: String, completion: @escaping () -> ()) {
        let ref = DataService.ds.REF_POSTS
        ref.queryOrdered(byChild: byChild).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.recipes.removeAll(keepingCapacity: true)
                for snap in snapshot {
                    
                    if let recipeDict = snap.value as? Dictionary<String, AnyObject> {
                        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
                            return
                        }

                        let key = snap.key
                        let recipe = Recipe(recipeId: key, recipeData: recipeDict)
                        if recipe.complaineUsers.contains(userId) {
                            continue
                        }
                        if recipe.complaineUsers.count > 3 {
                            continue
                        }
                        if let isComplaineUser = self.user?.complanedUsers.contains(recipe.fromId), isComplaineUser == true {
                            continue
                        }
                        self.recipes.append(recipe)
                        
                    }
                    
                }
                completion()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
            
        })
    }
    
    func fetchUserRecipes(byChild: String, completion: @escaping () -> ()) {
        let ref = DataService.ds.REF_POSTS
        guard let fromId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        ref.queryOrdered(byChild: byChild).queryEqual(toValue: fromId).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.recipes.removeAll(keepingCapacity: true)
                for snap in snapshot {
                    
                    if let recipeDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let recipe = Recipe(recipeId: key, recipeData: recipeDict)
                        self.recipes.append(recipe)
                        
                    }
                    
                }
                completion()
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
            
        })
    }
    
    func fetchUserData(completion: @escaping () -> ()) {
        
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = DataService.ds.REF_USERS.child(userId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let user = User()
            if let userName = dictionary["name"] as? String {
                user.userName = userName
            }
            if let complaineUsersDict = dictionary["complanedUsers"] as? [String:Int] {
                for (key, _) in complaineUsersDict {
                    user.complanedUsers.append(key)
                }
            }
            self.user = user
            completion()
        })
    }
    
    func editCell(cell: MainCell) {
        guard let indexPath = (collectionView.indexPath(for: cell)) else {
            return
        }
        let indexPathRow = indexPath.row
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let hideSource = UIAlertAction(title: "Hide Source of News", style: .default, handler: { action in
            let recipe = self.recipes[indexPathRow]
            recipe.copmlaineToRecipe(completion: {
                self.user?.addComplainedUser(fromUserId: recipe.fromId, completion: { 
                    DispatchQueue.main.async { [weak self] in
                        self?.recipes.remove(at: indexPathRow)
                        self?.collectionView.deleteItems(at: [indexPath])
                    }
                })
            })
            print("Hide news source")
        })
        let complainRecipe = UIAlertAction(title: "Hide and Complain", style: .default, handler: { action in
            let recipe = self.recipes[indexPathRow]
            recipe.copmlaineToRecipe(completion: { 
                DispatchQueue.main.async { [weak self] in
                    self?.recipes.remove(at: indexPathRow)
                    self?.collectionView.deleteItems(at: [indexPath])
                }
            })
        })
        alertController.addAction(complainRecipe)
        alertController.addAction(hideSource)
        alertController.addAction(cancelAction)
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            alertController.view.tintColor = .black
            if let currentPopoverpresentioncontroller = alertController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = cell.editRecipeButton
                currentPopoverpresentioncontroller.sourceRect = cell.buttonBlurView.bounds
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.down;
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            alertController.view.tintColor = .white
            present(alertController, animated: true, completion: nil)
            if let visualEffectView = alertController.view.searchVisualEffectsSubview()
            {
                visualEffectView.effect = UIBlurEffect(style: .dark)
            }
        }

        
        
    }
}
//MARK: MenuTransitionManagerDelegate
extension MainVC: MenuTransitionManagerDelegate {
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}
//MARK: UICollectionViewDataSource
extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let recipe = recipes[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainCell
        cell.mainVC = self
        cell.recipe = recipe
        return cell
        
    }
}

//MARK: UICollectionViewDelegate
extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        let controller = DetailVC()
        controller.recipe = recipes[indexPath.item]
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        activityIndicator.stopAnimating()
        
        if !shownIndexPath.contains(indexPath.item) {
            
            // Define the initial state (Before the animation)
            cell.alpha = 0
            
            // Define the final state (After the animation)
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1
            }
            
            shownIndexPath.insert(indexPath.item)
            
        }
        
    }
    
    
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 20, height: 244)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
