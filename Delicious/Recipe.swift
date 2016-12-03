//
//  Recipe.swift
//  Delicious
//
//  Created by Fomin Nickolai on 11/23/16.
//  Copyright © 2016 Fomin Nickolai. All rights reserved.
//

import Foundation
import Firebase

class Recipe {
    
    private var _title: String!
    private var _recipeImage: String!
    private var _timeToCook: String!
    private var _personCount: String!
    private var _instructions: String!
    private var _ingridients: String!
    private var _fromId: String!
    private var _recipeId: String!
    private var _recipeRef: FIRDatabaseReference!
    private var _timestamp: String!
    private var _imageNameInStorage: String!
    var likedPosts: [String] = []
    var complaineUsers: [String] = []
    
    var title: String {
        return _title
    }
    
    var recipeImage: String {
        return _recipeImage
    }
    
    var timeToCook: String {
        return _timeToCook
    }
    
    var personCount: String {
        return _personCount
    }
    
    var instructions: String {
        return _instructions
    }
    
    var ingridients: String {
        return _ingridients
    }
    
    var fromId: String {
        return _fromId
    }
    
    var timestamp: String {
        return _timestamp
    }
    
    var recipeId: String {
        return _recipeId
    }
    
    var imageNameInStorage: String {
        return _imageNameInStorage
    }
    
    
    init(recipeId: String, recipeData: Dictionary<String, AnyObject>) {
        
        self._recipeId = recipeId
        
        if let title = recipeData["title"] as? String {
            self._title = title
        }
        
        if let imageUrl = recipeData["recipeImage"] as? String {
            self._recipeImage = imageUrl
        }
        
        if let timeCook = recipeData["timeToCook"] as? String {
            self._timeToCook = timeCook
        }
        
        if let personCount = recipeData["personCount"] as? String {
            self._personCount = personCount
        }
        
        if let instructions = recipeData["instructions"] as? String {
            self._instructions = instructions
        }
        
        if let ingridients = recipeData["ingridients"] as? String {
            self._ingridients = ingridients
        }
        
        if let timestamp = recipeData["timestamp"] as? String {
            self._timestamp = timestamp
        }
        
        if let fromId = recipeData["fromId"] as? String {
            self._fromId = fromId
        }
        
        if let imageNameInStorage = recipeData["imageNameInStorage"] as? String {
            self._imageNameInStorage = imageNameInStorage
        }
                
        if let likedPostsDict = recipeData["likedPosts"] as? [String:Int] {
            for (key, _) in likedPostsDict {
                self.likedPosts.append(key)
            }
        }
        
        if let complaineUsersDict = recipeData["complaineUsers"] as? [String:Int] {
            for (key, _) in complaineUsersDict {
                self.complaineUsers.append(key)
            }
        }
        
        _recipeRef = DataService.ds.REF_POSTS.child(_recipeId)
    }
    
    func adjustLikes(addLike: Bool, completion: @escaping () -> ()) {
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        if addLike {
            _recipeRef.child("likedPosts").updateChildValues([userId: 1], withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }
                self.likedPosts.append(userId)
                completion()
            })
            
        } else {
            _recipeRef.child("likedPosts").child(userId).removeValue(completionBlock: { (error, ref) in
                self.likedPosts.remove(object: userId)
                completion()
            })
        }
        
    }
    
    func copmlaineToRecipe(completion: @escaping () -> ()) {
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        _recipeRef.child("complaineUsers").updateChildValues([userId: 1], withCompletionBlock: { (error, ref) in
            if error != nil {
                return
            }
            completion()
        })
    }
    
}
