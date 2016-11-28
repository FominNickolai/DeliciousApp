//
//  RegisterVC.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/26/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class RegisterVC: UIViewController {
    
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
    
    let nickNameTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Nickname", attributes: [NSForegroundColorAttributeName: UIColor.white])
        tf.font = UIFont(name: "HelveticaNeue", size: 16)
        tf.textColor = .white
        tf.layer.cornerRadius = 27
        tf.layer.masksToBounds = true
        tf.backgroundColor = UIColor(red:0,  green:0,  blue:0, alpha:0.4)
        tf.heightAnchor.constraint(equalToConstant: 55).isActive = true
        tf.textAlignment = .center
        return tf
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
        tf.clearsOnBeginEditing = true
        tf.layer.masksToBounds = true
        tf.backgroundColor = UIColor(red:0,  green:0,  blue:0, alpha:0.4)
        tf.heightAnchor.constraint(equalToConstant: 55).isActive = true
        tf.textAlignment = .center
        return tf
    }()
    
    lazy var registerWithEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 27
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red:1,  green:0.404,  blue:0.384, alpha:1)
        button.addTarget(self, action: #selector(handleRegisterWithEmail), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
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
        view.addSubview(backButton)
        
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
        mainStackView.spacing = 55
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 22
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainStackView)
        
        stackView.addArrangedSubview(nickNameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(registerWithEmailButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(stackView)
        
        mainStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: mainStackView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: mainStackView.rightAnchor).isActive = true
        
        titleLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        nickNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        registerWithEmailButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 31).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        backButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: Actions
extension RegisterVC {
    
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
    
    func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegisterWithEmail() {
        let alertVC = UIAlertController(title: "Notification", message: "Please fill in all the fields", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        guard let name = nickNameTextField.text, name != "" else {
            present(alertVC, animated: true, completion: nil)
            return
        }
        guard let email = emailTextField.text, email != "" else {
            present(alertVC, animated: true, completion: nil)
            return
        }
        guard  let password = passwordTextField.text, password != "" else {
            present(alertVC, animated: true, completion: nil)
            return
        }
        
        
        LoginService.standard.registerWithEmailAndPassword(email: email, password: password, name: name, completion: { (error) in
            
            if let firebaseError = error {
                switch firebaseError {
                case .errorCodeInvalidEmail:
                    self.showAlertActionWithTitleAndText(title: "Email", text: "Email you entered is not correct")
                    return
                case .errorCodeEmailAlreadyInUse:
                    self.showAlertActionWithTitleAndText(title: "Email", text: "Email you entered is already in use")
                    return
                case .errorCodeWeakPassword:
                    self.showAlertActionWithTitleAndText(title: "Password", text: "The password you entered is weak, at least 6 characters required")
                    return
                default:
                    self.showAlertActionWithTitleAndText(title: "Notification", text: "Something goes wrong, please try again")
                    return
                }
            }

            DispatchQueue.main.async {[unowned self] in
                self.dismiss(animated: true, completion: nil)
            }
        
        })
    }
    
    func showAlertActionWithTitleAndText(title: String, text: String) {
        let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}
