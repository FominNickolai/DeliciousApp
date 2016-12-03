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
                return
            }
            
            let userData = ["provider": credentials.provider, "name": user?.displayName]
            guard let userToWrite = user else {
                return
            }
            
            
            self.completeSignIn(id: userToWrite.uid, userData: userData as! Dictionary<String, String>)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            
            if error != nil {
                return
            }
        }
    }
    
    func loginWithEmailAndPassword(email: String, password: String, name: String = "", completion: @escaping (_ error: FIRAuthErrorCode?) -> ()) {
            
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    completion(errCode)
                    
                }
                
            } else {
                if let user = user {
                    _ = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    completion(nil)
                }
            }
        })
    }
    
    func registerWithEmailAndPassword(email: String, password: String, name: String = "", completion: @escaping (_ error: FIRAuthErrorCode?) -> ()) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    completion(errCode)
                    
                }
                
            } else {
                if let user = user {
                    let userData = ["provider" : user.providerID, "name": name]
                    self.completeSignIn(id: user.uid, userData: userData)
                    completion(nil)
                }
            }
        })
    }
    
    
    
    func resetPassword(email: String, completion: @escaping () -> ()) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            completion()
        })
    }
    
    private func completeSignIn(id: String, userData: Dictionary<String, String>) {
       
        _ = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        
    }
}
