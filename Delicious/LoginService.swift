//
//  LoginService.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/21/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class  LoginService {
    static let standard = LoginService()
    
    func loginWithFacebook(vc: UIViewController, completion: @escaping () -> ()) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: vc) { (result, err) in
            
            if err != nil {
                print("FB Login Failed")
                return
            }
            
            self.showEmailAddress()
            completion()
            
        }
    }
    
    private func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                
                print("Something went wrong with our FB user")
                return
                
            }
            let userData = ["provider": credentials.provider, "name": user?.displayName]
            guard let userToWrite = user else {
                return
            }
            self.completeSignIn(id: userToWrite.uid, userData: userData as! Dictionary<String, String>)
            print("Successfully logged in with our user")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            
            if error != nil {
                print("Failed to start grab request")
                return
            }
            
            print(result ?? "")
            
        }
        
    }
    
    func loginWithEmailAndPassword(email: String, password: String, completion: @escaping () -> ()) {
            
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil {
                
                print("NICK: Email user authenticated Successfully with Firebase")
                
                if let user = user {
                    
                    let userData = ["provider" : user.providerID]
                    self.completeSignIn(id: user.uid, userData: userData)
                    completion()
                    
                }
                
            } else {
                
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print("NICK: Unable to authenticate with Firebase using email")
                    } else {
                        print("NICK: Successfully created user in Firebase")
                        
                        if let user = user {
                            let userData = ["provider" : user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData)
                            completion()
                        }
                    }
                })
                
            }
            
        })

    }
    
    private func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        _ = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        
        
        print("NICK: Data saved to keychain successfully")
    }
}
