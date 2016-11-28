//
//  ViewController.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "screenBg")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: -3, height: 0)
        shadow.shadowColor = UIColor.black
        let attributes = [
            NSShadowAttributeName : shadow,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont(name: "SnellRoundhand-Bold", size: 61)
        ]
        label.attributedText = NSAttributedString(string: "Delicious", attributes: attributes)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        tf.keyboardType = .emailAddress
        tf.font = UIFont(name: "HelveticaNeue", size: 16)
        tf.textColor = .white
        tf.layer.cornerRadius = 27
        tf.layer.masksToBounds = true
        tf.backgroundColor = UIColor(red:0,  green:0,  blue:0, alpha:0.4)
        tf.heightAnchor.constraint(equalToConstant: 55).isActive = true
        tf.textAlignment = .center
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        tf.isSecureTextEntry = true
        tf.font = UIFont(name: "HelveticaNeue", size: 16)
        tf.textColor = .white
        tf.clearsOnBeginEditing = true
        tf.layer.cornerRadius = 27
        tf.layer.masksToBounds = true
        tf.backgroundColor = UIColor(red:0,  green:0,  blue:0, alpha:0.4)
        tf.heightAnchor.constraint(equalToConstant: 55).isActive = true
        tf.textAlignment = .center
        return tf
    }()
    
    lazy var signInWithEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 27
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        button.addTarget(self, action: #selector(handleSignInWithEmail), for: .touchUpInside)
        return button
    }()
    
    lazy var signInWithFacebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In with Facebook", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 27
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red:0.294,  green:0.431,  blue:0.659, alpha:1)
        button.addTarget(self, action: #selector(handleSignInWithFacebook), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: -1, height: 0)
        shadow.shadowColor = UIColor.black
        let attributes = [
            NSShadowAttributeName : shadow,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)
        ]
        let attributedText = NSAttributedString(string: "Create an Account", attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()
    
    lazy var helpButton: UIButton = {
        let button = UIButton(type: .system)
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: -1, height: 0)
        shadow.shadowColor = UIColor.black
        let attributes = [
            NSShadowAttributeName : shadow,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)
        ]
        let attributedText = NSAttributedString(string: "Need Help?", attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(handleResetPasswordButton), for: .touchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        view.addSubview(backgroundImageView)
        view.addSubview(containerView)
        
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        bottomConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        bottomConstraint?.isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9, constant: 0).isActive = true
        
        
        //Stack View
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .center
        mainStackView.spacing = 35
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 22
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackHorizontalView = UIStackView()
        stackHorizontalView.axis = .horizontal
        stackHorizontalView.distribution = .fillEqually
        stackHorizontalView.alignment = .center
        stackHorizontalView.spacing = 0
        stackHorizontalView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainStackView)
        containerView.addSubview(stackHorizontalView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInWithEmailButton)
        stackView.addArrangedSubview(signInWithFacebookButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(stackView)
        
        stackHorizontalView.addArrangedSubview(registerButton)
        stackHorizontalView.addArrangedSubview(helpButton)
        
        mainStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: mainStackView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: mainStackView.rightAnchor).isActive = true
        
        stackHorizontalView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        stackHorizontalView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        stackHorizontalView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 30).isActive = true
        stackHorizontalView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        titleLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        signInWithEmailButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        signInWithFacebookButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true   
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            presentMainVC()
        }
        
    }
    fileprivate func presentMainVC() {
        let controller = MainVC()
        let navController = UINavigationController(rootViewController: controller)
        navController.viewControllers = [controller]
        present(navController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("LoginVC deinit")
    }
}
//MARK: Actions
extension LoginVC {
    
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
        LoginService.standard.loginWithEmailAndPassword(email: email, password: password, completion: { (error) in
            
            if let firebaseError = error {
                switch firebaseError {
                case .errorCodeInvalidEmail, .errorCodeWrongPassword:
                    self.showAlertActionWithTitleAndText(title: "Notification", text: "Email or Password is not correct")
                    return
                case .errorCodeUserNotFound:
                    self.showAlertActionWithTitleAndText(title: "Notification", text: "User is not found")
                    return
                default:
                    self.showAlertActionWithTitleAndText(title: "Notification", text: "Something goes wrong, please try again")
                    return
                }
            }
            DispatchQueue.main.async {[unowned self] in
                self.presentMainVC()
            }
        })
    }
    
    func showAlertActionWithTitleAndText(title: String, text: String) {
        let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func handleSignInWithFacebook() {
        LoginService.standard.loginWithFacebook(vc: self, completion: {
            let accessToken = FBSDKAccessToken.current()
            if (accessToken?.tokenString) != nil {
                DispatchQueue.main.async {[unowned self] in
                    self.presentMainVC()
                }
            }
        })
    }
    
}

