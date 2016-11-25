//
//  DetailVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/22/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import Firebase

class DetailVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 200)
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
    
    let cellImageId = "cellId"
    let cellTitleId = "cellTitleId"
    let cellTextId = "cellTextId"
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fromId = FIRAuth.auth()?.currentUser?.uid
        if fromId == recipe?.fromId {
            
            navigationItem.rightBarButtonItems = [deleteBarButton, editBarButton]
            
        }
        
        
        
        view.addSubview(imageView)
        view.addSubview(blurView)
        
        view.addSubview(collectionView)
        
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
 
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.backgroundColor = .clear
        collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: cellImageId)
        collectionView.register(DetailTitleCell.self, forCellWithReuseIdentifier: cellTitleId)
        collectionView.register(DetailTextCell.self, forCellWithReuseIdentifier: cellTextId)
    }
    
    fileprivate func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: UIScreen.main.bounds.width - 60, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 16)!], context: nil)
        
    }
    
    deinit {
        print("DetailVC Deinit")
    }
    
}

//Actions
extension DetailVC {
    func handleEditButton() {
        
        let addVC = AddVC()
        addVC.recipe = self.recipe
        navigationController?.pushViewController(addVC, animated: true)
        
        
    }
    
    func handleDeleteButton() {
        
        let alertController = UIAlertController(title: "Deleting", message: "Are you really want to delete this Recipe?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.deleteRecipeFromDatabase()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            
            
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteRecipeFromDatabase() {
        if let recipeId = recipe?.recipeId {
            FIRDatabase.database().reference().child("posts").child(recipeId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message")
                    return
                }
                print("Succelssfully deleted")
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
}

//UICollectionViewDataSource
extension DetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellImageId, for: indexPath) as! DetailImageCell
            if let imageUrl = recipe?.recipeImage {
                cell.imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
            }
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTitleId, for: indexPath) as! DetailTitleCell
                cell.recipe = recipe
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTextId, for: indexPath) as! DetailTextCell
            if indexPath.item == 2 {
                cell.recipeText = recipe?.ingridients
                cell.titleCellTopView.text = "Ingridients"
            } else {
                cell.recipeText = recipe?.instructions
                cell.titleCellTopView.text = "Instructions"

            }

            return cell
        }
    
    }
}

//UICollectionViewDelegate
extension DetailVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}

//UICollectionViewDelegateFlowLayout
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
        print(height)
        return CGSize(width: view.frame.width - 20, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(75, 0, 0, 0)
        
    }
    
}
