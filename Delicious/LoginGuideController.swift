//
//  LoginGuideController.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/27/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class LoginGuideController: UIViewController {
    
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
        pc.numberOfPages = self.pages.count - 1
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
        
        let fourthPage = Page(title: "", message: "", imageName: "")
        
        return [firstPage, secondPage, thirdPage, fourthPage]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print("LoginController deinit")
    }
    
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    func nextPage() {
        if pageController.currentPage == pages.count - 2 {
            showLoginVC()
        }

        
        let indexPath = IndexPath(item: pageController.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageController.currentPage += 1
    }
    
    func skip() {
        
        pageController.currentPage = pages.count
        nextPage()
        
    }
    
    func dismissLoginGiude() {
        dismiss(animated: true, completion: nil)
    }
    
    func showLoginVC() {
        let loginVC = LoginVC()
        loginVC.giudeVC = self
        present(loginVC, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageController.currentPage = pageNumber
        
        //we are on the last page
        if pageNumber == pages.count - 1 {
            showLoginVC()
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

extension LoginGuideController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let page = pages[indexPath.item]
        cell.page = page
        
        return cell
    }
    
}

extension LoginGuideController: UICollectionViewDelegate {
    
    
}

extension LoginGuideController: UICollectionViewDelegateFlowLayout {
    
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
