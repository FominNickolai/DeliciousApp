//
//  LoginCell.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/28/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    weak var delegate: LoginControllerDelegate?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapRecognizer)
        
        addSubview(backgroundImageView)
        addSubview(containerView)
        
        backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        bottomConstraint = containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        bottomConstraint?.isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9, constant: 0).isActive = true
        
        
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
    
    func handleLogin() {
        
        delegate?.finishLogginIn()
        
    }
    
    fileprivate func presentMainVC() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? MainNavigationController else {
            return
        }
        
        mainNavigationController.viewControllers = [MainVC()]
        
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Actions
extension LoginCell {
    
    
    
}
