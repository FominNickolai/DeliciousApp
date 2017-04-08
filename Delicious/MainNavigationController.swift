//
//  MainNavigationController.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/28/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            let loginVC = LoginVC()
            viewControllers = [loginVC]
        }else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)

        }

    }
    
    func showLoginController() {
        let loginController = LoginVC()
        present(loginController, animated: true, completion: {
            //perhaps we'll do something here later
        })
    }
    
    deinit {
        print("MainNavigationController deinit")
    }
    
}
