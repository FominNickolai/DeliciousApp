//
//  AddVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/23/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Firebase

class AddVC: UIViewController, UINavigationControllerDelegate {
    
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
    
    lazy var saveBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton))
        button.tintColor = .white
        return button
    }()
    
    let cellImageId = "cellId"
    let cellTitleId = "cellTitleId"
    let cellIngridientsId = "cellIngridientsId"
    let cellInstructionsId = "cellInstructionsId"
    
    let propertiesArray = ["title", "timeToCook", "personCount", "ingridients", "instructions"]
    
    var recipeToSend: [String: String] = [:] {
        didSet {
            for key in propertiesArray {
                if recipeToSend[key] == nil || recipeToSend[key] == "" {
                    saveBarButton.isEnabled = false
                    return
                }
            }
            saveBarButton.isEnabled = true
        }
    }
    
    var imageRecipe: UIImage?
    
    var recipe: Recipe?
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = saveBarButton
        if recipe != nil {
            saveBarButton.isEnabled = true
            recipeToSend["title"] = recipe?.title
            recipeToSend["timeToCook"] = recipe?.timeToCook
            recipeToSend["personCount"] = recipe?.personCount
            recipeToSend["ingridients"] = recipe?.ingridients
            recipeToSend["instructions"] = recipe?.instructions
            recipeToSend["recipeImage"] = recipe?.recipeImage
            recipeToSend["imageNameInStorage"] = recipe?.imageNameInStorage
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
        view.addConstraint(bottomConstraint!)
        collectionView.backgroundColor = .clear
        collectionView.register(AddImageCell.self, forCellWithReuseIdentifier: cellImageId)
        collectionView.register(AddTitleCell.self, forCellWithReuseIdentifier: cellTitleId)
        collectionView.register(AddIngrideintsCell.self, forCellWithReuseIdentifier: cellIngridientsId)
        collectionView.register(AddInstructionsCell.self, forCellWithReuseIdentifier: cellInstructionsId)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapRecognizer.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tapRecognizer)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: Actions
extension AddVC {
    func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keybardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            //move the input area somehow
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keybardFrame!.height : 0
            
            UIView.animate(withDuration: keyboardDuration!, delay: 0, options: .curveEaseOut, animations: {
                
                //when we need to animate constraints we call layoutIfNeeded()
                self.view.layoutIfNeeded()
                
            }, completion: { (finished) in

            })
            
            
        }
        
    }
    
    func handleSingleTap() {
        self.view.endEditing(true)
    }
    
    func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func handleSaveButton() {
        self.saveBarButton.isEnabled = false
        let alertController = UIAlertController(title: "Great", message: "Successfully Saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            
            DispatchQueue.main.async(execute: { 
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            
        })
        
        alertController.addAction(okAction)
        
        if let image = imageRecipe {
            uploadToFirebaseStorageUsingImage(image: image, completion: { (imageUrl, imageName) in
                self.recipeToSend["recipeImage"] = imageUrl
                self.recipeToSend["imageNameInStorage"] = imageName
                self.saveRicepeToDatabase(properties: self.recipeToSend, completion: { 
                    self.present(alertController, animated: true, completion: nil)
                    self.saveBarButton.isEnabled = true
                })
            })
        }
    }
    
    fileprivate func saveRicepeToDatabase(properties: [String: String], completion: @escaping () -> ()) {
        var baseRef: FIRDatabaseReference
        let ref = DataService.ds.REF_POSTS
        guard let fromId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let timeStamp = String(Int(Date().timeIntervalSince1970))
    
        var values: [String: AnyObject] = ["fromId": fromId as AnyObject, "timestamp": timeStamp as AnyObject]
        
        properties.forEach { (key, value) in
            values[key] = value as AnyObject?
        }
        
        if recipe != nil {
            guard let key = recipe?.recipeId else {
                return
            }
            baseRef = ref.child(key)
        } else {
            baseRef = ref.childByAutoId()
        }
        baseRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
            
            if error != nil {
                return
            }
            completion()
        })
    }
    
    fileprivate func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageUrl: String, _ imageName: String) -> ()) {
        var imageName: String
        if let oldImageName = recipe?.imageNameInStorage {
            imageName = oldImageName
        } else {
            imageName = NSUUID().uuidString
        }
        let ref = DataService.ds.REF_POST_IMAGES.child(imageName)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        if let uploadData = UIImageJPEGRepresentation(image, 0.5) {
            ref.put(uploadData, metadata: metadata, completion: { (metadata, error) in
                
                if error != nil {
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl, imageName)
                }
                
            })
        }
        
    }
    
//    fileprivate func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage? {
//        
//        let asset = AVAsset(url: fileUrl)
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        
//        do {
//            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
//            
//            return UIImage(cgImage: thumbnailCGImage)
//        } catch {
//            
//        }
//        
//        return nil
//        
//    }
    
//    fileprivate func handleVideoSelectedForUrl(url: URL) {
//        var videoName: String
//        if let oldVideoName = recipe?.videoNameInStorage {
//            videoName = oldVideoName
//        } else {
//            videoName = NSUUID().uuidString
//        }
//        let uploadTask = DataService.ds.REF_POST_VIDEOS.child(videoName).putFile(url, metadata: nil, completion: { (metadata, error) in
//        
//            if error != nil {
//                print("Error to upload video")
//                return
//            }
//            
//            if let videoUrl = metadata?.downloadURL()?.absoluteString {
//                
//                
//                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url) {
//                    
//                    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl, imageName) in
//                        
//                        let indexPath = IndexPath(item: 0, section: 0)
//                        let cell = self.collectionView.cellForItem(at: indexPath) as! AddImageCell
//                        DispatchQueue.main.async(execute: { 
//                            cell.setImage = thumbnailImage
//                            self.imageRecipe = thumbnailImage
//                        })
//                        
//                        
//                        self.recipeToSend["recipeImage"] = imageUrl
//                        self.recipeToSend["imageNameInStorage"] = imageName
//                        self.recipeToSend["videoUrl"] = videoUrl
//                        self.recipeToSend["videoNameInStorage"] = videoName
////                        self.saveRicepeToDatabase(properties: self.recipeToSend, completion: {
////                            //self.present(alertController, animated: true, completion: nil)
////                            self.saveBarButton.isEnabled = true
////                        })
//                        
//                    })
//                    
//                }
//                
//            }
//            
//        })
//        
//        uploadTask.observe(.progress, handler: { (snapshot) in
//            
//            if let completedUnitCount = snapshot.progress?.completedUnitCount {
//                print(String(completedUnitCount))
//            }
//            
//            
//            
//        })
//        
//        uploadTask.observe(.success, handler: {(snapshot) in
//            
//            print("Successfuly upload video")
//            
//            
//        })
//        
//    }
    
}

//MARK: UICollectionViewDataSource
extension AddVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellImageId, for: indexPath) as! AddImageCell
            cell.addVC = self
            if recipe != nil {
                let imageView = UIImageView()
                imageView.loadImageUsingCacheWithUrlString(urlString: (recipe?.recipeImage)!, completion: nil)
                cell.uploadImageView.image = imageView.image
                self.imageRecipe = imageView.image
                cell.addButtonImage.alpha = 0.2
            }
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellTitleId, for: indexPath) as! AddTitleCell
            cell.cellTitle.delegate = self
            cell.cellTitle.tag = 1
            cell.timeToCook.delegate = self
            cell.timeToCook.tag = 2
            cell.personCount.delegate = self
            cell.personCount.tag = 3
            if recipe != nil {
                cell.cellTitle.text = recipe?.title
                cell.timeToCook.text = recipe?.timeToCook
                cell.personCount.text = recipe?.personCount
            }
            return cell
        } else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIngridientsId, for: indexPath) as! AddIngrideintsCell
            cell.textView.delegate = self
            cell.textView.tag = 1
            if recipe != nil {
                cell.textView.text = recipe?.ingridients
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellInstructionsId, for: indexPath) as! AddInstructionsCell
            cell.textView.delegate = self
            cell.textView.tag = 2
            if recipe != nil {
                cell.textView.text = recipe?.instructions
            }
            return cell
        }
    }
}
//MARK: UITextFieldDelegate
extension AddVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            recipeToSend["title"] = textField.text!
        case 2:
            recipeToSend["timeToCook"] = textField.text!
        case 3:
            recipeToSend["personCount"] = textField.text!
        default:
            break
        }
    }
}
//MARK: UITextViewDelegate
extension AddVC: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView.tag {
        case 1:
            recipeToSend["ingridients"] = textView.text!
        case 2:
            recipeToSend["instructions"] = textView.text!
        default:
            break
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView.tag {
        case 1:
            let indexPath = IndexPath(item: 2, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        case 2:
            let indexPath = IndexPath(item: 3, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        default:
            break
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension AddVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 0
        if indexPath.item == 0 {
            height = 244
        } else if indexPath.item == 1 {
            height =  103
        } else {
            height = 300
        }
        return CGSize(width: view.frame.width - 20, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(75, 0, 0, 0)
        
    }
    
}
//MARK: UIImagePickerControllerDelegate
extension AddVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            //handleVideoSelectedForUrl(url: videoUrl)
            
        } else {
            handleImageSelectedForInfo(info: info)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func handleImageSelectedForInfo(info: [String: Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage]  as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            let indexPath = IndexPath(item: 0, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! AddImageCell
            cell.setImage = selectedImage
            imageRecipe = selectedImage
        }
    }
}
