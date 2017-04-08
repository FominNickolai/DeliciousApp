//
//  User.swift
//  Delicious
//
//  Created by admin on 11/25/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    var userName: String?
    var complanedUsers:[String] = []
    
    func addComplainedUser(fromUserId: String, completion: @escaping () -> ()) {
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = DataService.ds.REF_USERS.child(userId)
        ref.child("complanedUsers").updateChildValues([fromUserId: 1], withCompletionBlock: { (error, ref) in
            if error != nil {
                return
            }
            completion()
        })
    }
}
