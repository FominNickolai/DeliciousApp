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
    private var _imageUrl: String!
    private var _timeCook: String!
    private var _personCount: String!
    private var _descriptionSteps: String!
    private var _ingridients: String!
    private var _recipeKey: String!
    private var _likes: Int!
    private var _recipeRef: FIRDatabaseReference!
    
    var title: String {
        return _title
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var timeCook: String {
        return _timeCook
    }
    
    var personCount: String {
        return _personCount
    }
    
    var descriptionSteps: String {
        return _descriptionSteps
    }
    
    var ingridients: String {
        return _ingridients
    }
    
    var likes: Int {
        return _likes
    }
    
    var recipeKey: String {
        return _recipeKey
    }
    
    init(title: String, imageUrl: String, likes: Int) {
        
        self._title = title
        self._imageUrl = imageUrl
        self._likes = likes
        
    }
    
    init(recipeKey: String, recipeData: Dictionary<String, AnyObject>) {
        
        self._recipeKey = recipeKey
        
        if let title = recipeData["title"] as? String {
            self._title = title
        }
        
        if let imageUrl = recipeData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let timeCook = recipeData["timeCook"] as? String {
            self._timeCook = timeCook
        }
        
        if let personCount = recipeData["personCount"] as? String {
            self._personCount = personCount
        }
        
        if let descriptionSteps = recipeData["descriptionSteps"] as? String {
            self._descriptionSteps = descriptionSteps
        }
        
        if let ingridients = recipeData["ingridients"] as? String {
            self._ingridients = ingridients
        }
        
        if let likes = recipeData["likes"] as? Int {
            self._likes = likes
        }
        
        _recipeRef = DataService.ds.REF_POSTS.child(_recipeKey)
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
