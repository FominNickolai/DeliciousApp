//
//  DetailVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/22/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import Social

class DetailVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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
    
    lazy var editBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditButton))
        button.tintColor = .white
        return button
    }()
    
    lazy var deleteBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "delete-button"), style: .plain, target: self, action: #selector(handleDeleteButton))
        button.tintColor = .white
        return button
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.318,  green:0.318,  blue:0.318, alpha:0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let activityIndicator: NVActivityIndicatorView = {
        let activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activity.type = .ballTrianglePath
        activity.color = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    lazy var shareBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "share-file"), style: .plain, target: self, action: #selector(handleShareButton))
        button.tintColor = .white
        return button
    }()

    
    
    let cellImageId = "cellId"
    let cellTitleId = "cellTitleId"
    let cellTextId = "cellTextId"
    
    var recipe: Recipe?
    var user: User?
    
    var startingFrame: CGRect?
    var blackBackground: UIView?
    var startingImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fromId = FIRAuth.auth()?.currentUser?.uid
        if fromId == recipe?.fromId {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                navigationItem.rightBarButtonItems = [deleteBarButton, shareBarButton, editBarButton]
            } else {
                navigationItem.rightBarButtonItems = [deleteBarButton, editBarButton]
            }
        } else {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                navigationItem.rightBarButtonItems = [shareBarButton]
            }
        }
        
        view.addSubview(imageView)
        view.addSubview(blurView)
        view.addSubview(collectionView)
        view.addSubview(bgView)
        bgView.addSubview(activityIndicator)
        
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        bgView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bgView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.backgroundColor = .clear
        collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: cellImageId)
        collectionView.register(DetailTitleCell.self, forCellWithReuseIdentifier: cellTitleId)
        collectionView.register(DetailTextCell.self, forCellWithReuseIdentifier: cellTextId)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: UIScreen.main.bounds.width - 60, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 16)!], context: nil)
        
    }
    
    deinit {
    }
    
}

//MARK: Actions
extension DetailVC {
    
    func handleShareButton() {
        let shareActionSheet = UIAlertController(title: "Facebook", message: "Share recipe to your friends by Facebook?", preferredStyle: .alert)
        let facebookShareAction = UIAlertAction(title: "Share", style: .default, handler: { (action) in
        
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                let imageView = UIImageView()
                imageView.loadImageUsingCacheWithUrlString(urlString: self.recipe!.recipeImage, completion: {
                    if let image = imageView.image {
                        facebookComposer?.add(image)
                    }
                })
                self.present(facebookComposer!, animated: true, completion: nil)
                
            } else {
                return
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        shareActionSheet.addAction(facebookShareAction)
        shareActionSheet.addAction(cancelAction)
        
        present(shareActionSheet, animated: true, completion: nil)
        
    }
    
    func handleEditButton() {
        let addVC = AddVC()
        addVC.recipe = self.recipe
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    func handleDeleteButton() {
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this Recipe?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.deleteRecipeFromDatabase()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteRecipeFromDatabase() {
        if let recipeImageName = recipe?.imageNameInStorage {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.bgView.isHidden = false
                self.activityIndicator.startAnimating()
                
            })
            DataService.ds.REF_POST_IMAGES.child(recipeImageName).delete(completion: { (error) in
                if error != nil {
                    return
                }
                
                if let recipeId = self.recipe?.recipeId {
                    DataService.ds.REF_POSTS.child(recipeId).removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                            return
                        }
                        
                        DispatchQueue.main.async(execute: { [weak self] in
                            let alertController = UIAlertController(title: "Success", message: "You have successfully deleted this recipe", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { action in
                                _ = self?.navigationController?.popToRootViewController(animated: true)
                            })
                            alertController.addAction(okAction)
                            self?.bgView.removeFromSuperview()
                            self?.present(alertController, animated: true, completion: nil)
                            
                        })
                    })
                    
                }
                
            })
        }
        
    }
    
    func changeLikesValue() {
               
        if checkIfLiked() {
            self.recipe?.adjustLikes(addLike: false, completion: { 
                let indexPath = IndexPath(item: 1, section: 0)
                let cell = self.collectionView.cellForItem(at: indexPath) as! DetailTitleCell
                DispatchQueue.main.async(execute: {
                    cell.isFavoriteButton.setImage(UIImage(named: "inactive_heart"), for: .normal)
                })
            })
        } else {
            self.recipe?.adjustLikes(addLike: true, completion: { 
                let indexPath = IndexPath(item: 1, section: 0)
                let cell = self.collectionView.cellForItem(at: indexPath) as! DetailTitleCell
                DispatchQueue.main.async(execute: {
                    cell.isFavoriteButton.setImage(UIImage(named: "active_heart"), for: .normal)
                })
            })
        }
    }
    
    func checkIfLiked() -> Bool {
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            return false
        }
        guard let isLiked = recipe?.likedPosts.contains(userId) else {
            return false
        }
        return isLiked
    }
    
    
    //My custom zooming logic
    func performZoomInForStartindImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.contentMode = .scaleAspectFill
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow =  UIApplication.shared.keyWindow {
            
            blackBackground = UIView(frame: keyWindow.frame)
            blackBackground?.backgroundColor = .black
            blackBackground?.alpha = 0
            keyWindow.addSubview(blackBackground!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackground?.alpha = 1

                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
        }
        
        
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 8
            zoomOutImageView.clipsToBounds = true
            //animate back
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackground?.alpha = 0
                
            }, completion: { (completed) in
                
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
            })
            
        }
        
    }
    
}

//MARK: UICollectionViewDataSource
extension DetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellImageId, for: indexPath) as! DetailImageCell
            cell.detailVC = self
            if let imageUrl = recipe?.recipeImage {
                cell.imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl, completion: {
                
                    cell.activityIndicator.stopAnimating()
                
                })
            }
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTitleId, for: indexPath) as! DetailTitleCell
            cell.detailVC = self
            cell.recipe = recipe
            if checkIfLiked() {
                cell.isFavoriteButton.setImage(UIImage(named: "active_heart"), for: .normal)
            } else {
                cell.isFavoriteButton.setImage(UIImage(named: "inactive_heart"), for: .normal)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTextId, for: indexPath) as! DetailTextCell
            if indexPath.item == 2 {
                cell.recipeText = recipe?.ingridients
                cell.isIngridients = true
            } else {
                cell.recipeText = recipe?.instructions
                cell.isIngridients = false

            }

            return cell
        }
    
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension DetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        var height: CGFloat = 0
        if indexPath.item == 0 {
            height = 244
        } else if indexPath.item == 1 {
            height =  103
        } else {
            
            var messageText: String = ""
            if indexPath.item == 2, let text = recipe?.ingridients {
                messageText = text
            } else if indexPath.item == 3, let text = recipe?.instructions {
                messageText = text
            }
            
            height = estimateFrameForText(text: messageText).height + 100
        }
        return CGSize(width: view.frame.width - 20, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(75, 0, 0, 0)
        
    }
    
}
