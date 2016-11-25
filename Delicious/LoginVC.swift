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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)
        view.addSubview(containerView)
        
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -200).isActive = true
        
        //Stack View
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .center
        mainStackView.spacing = 55
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 22
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainStackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInWithEmailButton)
        stackView.addArrangedSubview(signInWithFacebookButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(stackView)
        
        mainStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: mainStackView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: mainStackView.rightAnchor).isActive = true
        
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
        print("LoginVC deinit")
    }
}
//MARK: Actions
extension LoginVC {
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

