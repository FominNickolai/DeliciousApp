//
//  MenuTransitionManager.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

protocol MenuTransitionManagerDelegate {
    func dismiss()
}

class MenuTransitionManager: NSObject {
    let duration = 0.5
    var isPresenting = false
    var snapshot:UIView? {
        didSet {
            
            if let delegate = delegate {
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: Selector(("dismiss")))
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
                
                let swipeLeft = UISwipeGestureRecognizer(target: delegate, action: Selector(("dismiss")))
                swipeLeft.direction = UISwipeGestureRecognizerDirection.left
                snapshot?.addGestureRecognizer(swipeLeft)
                
            }
            
        }
    }
    
    var delegate: MenuTransitionManagerDelegate?
}

extension MenuTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}

extension MenuTransitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let container = transitionContext.containerView
        
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        let moveRight = CGAffineTransform(translationX: container.frame.width / 1.5, y: 0)
        let moveLeft = CGAffineTransform(translationX: 0, y: 0)
        let makeScale = CGAffineTransform(scaleX: 1, y: 0.95)
        let concat = makeScale.concatenating(moveRight)
        
        // Add both views to the container view
        if isPresenting {
            toView.transform = offScreenLeft
            snapshot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 2.2, initialSpringVelocity: 2.2, options: [], animations: {
            
            if self.isPresenting {
                self.snapshot?.transform = concat
                toView.transform = CGAffineTransform.identity
            } else {
                self.snapshot?.transform = CGAffineTransform.identity
                fromView.transform = moveLeft
                
            }
            
        }) { (finished) in
            
            transitionContext.completeTransition(finished)
            
            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
            
        }
        
    }
    
}
