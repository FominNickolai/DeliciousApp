//
//  LoginGuideVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/28/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

protocol LoginControllerDelegate: class {
    func finishLogginIn()
    func handleRegisterButton()
    func handleResetPasswordButton()
}

class LoginGuideVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    lazy var pageController: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.pages.count + 1
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    let cellId = "cellId"
    let loginCellId = "loginCellId"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Share a great listen", message: "It's free to send your books to the people in your life. Every recipient's first book is on us.", imageName: "page1")
        
        let secondPage = Page(title: "Send from your library", message: "Tap the More menu next to any book. Choose \"Send this Book\"", imageName: "page2")
        
        let thirdPage = Page(title: "Send from the player", message: "Tap the More menu in the upper corner. Choose \"Send this Book\"", imageName: "page3")
        
        return [firstPage, secondPage, thirdPage]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
        
        view.addSubview(collectionView)
        view.addSubview(pageController)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        //use autolayout
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        pageControlBottomAnchor = pageController.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)[1]
        skipButtonTopAnchor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50)[0]
        nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50)[0]
        
        registerCells()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("LoginController deinit")
    }
    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func nextPage() {
        if pageController.currentPage == pages.count {
            return
        }
        
        if pageController.currentPage == pages.count - 1 {
            
            moveControlConstraintsOffScreen()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
        
        let indexPath = IndexPath(item: pageController.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageController.currentPage += 1
    }
    
    func skip() {
        
        pageController.currentPage = pages.count - 1
        nextPage()
        
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -50
            self.view.frame = CGRect(x: 0, y:y, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func keyboardHide() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageController.currentPage = pageNumber
        
        //we are on the last page
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        } else {
            pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 16
            nextButtonTopAnchor?.constant = 16
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControlBottomAnchor?.constant = 40
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
    }
    
    
}

extension LoginGuideVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let page = pages[indexPath.item]
        cell.page = page
        
        return cell
    }
    
}

extension LoginGuideVC: UICollectionViewDelegate {
    
    
}

extension LoginGuideVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //        print(UIDevice.current.orientation.isLandscape)
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageController.currentPage, section: 0)
        
        //scroll to indexpath after the rotation is going
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
        
        
    }
    
}

extension LoginGuideVC: LoginControllerDelegate {
    
    internal func finishLogginIn() {
        
        //we'll perhaps implement the home controller a little later
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? MainNavigationController else {
            return
        }
        
        mainNavigationController.viewControllers = [MainVC()]
                
        dismiss(animated: true, completion: nil)
        
    }
    
    func handleRegisterButton() {
        let registerVC = RegisterVC()
        present(registerVC, animated: true, completion: nil)
    }
    
    func handleResetPasswordButton() {
        let recoverPassVC = RecoverPassVC()
        present(recoverPassVC, animated: true, completion: nil)
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keybardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            //move the input area somehow
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keybardFrame!.height / 2 : 0
            
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
    
    func handleSignInWithEmail() {
        guard let email = emailTextField.text else {
            return
        }
        guard  let password = passwordTextField.text else {
            return
        }
        LoginService.standard.loginWithEmailAndPassword(email: email, password: password, completion: {
            DispatchQueue.main.async {
                self.presentMainVC()
            }
        })
    }
    
    func handleSignInWithFacebook() {
        LoginService.standard.loginWithFacebook(vc: self, completion: {
            DispatchQueue.main.async {
                self.presentMainVC()
            }
        })
    }
    
}
