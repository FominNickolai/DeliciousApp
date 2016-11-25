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
    private var _likes: Int!
    private var _recipeRef: FIRDatabaseReference!
    private var _timestamp: String!
    
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
    
    var likes: Int {
        return _likes
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
    
    init(title: String, recipeImage: String, likes: Int) {
        
        self._title = title
        self._recipeImage = recipeImage
        self._likes = likes
        
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
        
        if let likes = recipeData["likes"] as? Int {
            self._likes = likes
        }
        
        if let fromId = recipeData["fromId"] as? String {
            self._fromId = fromId
        }
        
        _recipeRef = DataService.ds.REF_POSTS.child(_fromId)
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            
            _likes = _likes + 1
            
        } else {
            
            _likes = _likes - 1
            
        }
        
        _recipeRef.child("likes").setValue(_likes)
    }
    
}
