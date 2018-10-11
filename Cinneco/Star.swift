//
//  Star.swift
//  Cinneco
//
//  Created by Asher Ahsan on 03/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation
class Star {
    private var id: Int!
    private var castId: Int?
    private var creditId: String?
    private var order: Int?
    private var name: String!
    private var character: String?
    private var gender: Int?
    private var profilePicPath: String?
    
    
    var getId: Int! {
        return self.id
    }
    
    var getCastId: Int? {
        return self.castId
    }
    
    var getCreditId: String? {
        return self.creditId
    }
    
    var getOrder: Int? {
        return self.order
    }
    
    var getName: String! {
        return self.name
    }
    
    var getCharacter: String? {
        return self.character
    }
    
    var getGender: Int? {
        return self.gender
    }
    
    var getProfilePicPath: String? {
        return self.profilePicPath
    }

    init(data: [String: AnyObject]) {
        //self.id = data["id"] as! Int
        //self.cast_id = data["cast_id"] as! Int
        //self.credit_id = data["credit_id"] as! String
        //self.order = data["order"] as! Int
        //self.name = data["name"] as! String
        //self.character = data["character"] as! String
        //self.gender = data["gender"] as! Int
        
        
        if data["id"] != nil {
            self.id = data["id"] as? Int
        } else {
            self.id = nil
        }
        
        if data["cast_id"] != nil {
            self.castId = data["cast_id"] as? Int
        } else {
            self.castId = nil
        }
        
        if data["credit_id"] != nil {
            self.creditId = data["credit_id"] as? String
        } else {
            self.creditId = nil
        }
        
        if data["name"] != nil {
            self.name = data["name"] as! String
        } else {
            self.name = nil
        }
        
        if data["character"] != nil {
            self.character = data["character"] as? String
        } else {
            self.character = nil
        }
        
        if data["gender"] != nil {
            self.gender = data["gender"] as? Int
        } else {
            self.gender = nil
        }
        
        if data["profile_path"] != nil {
            self.profilePicPath = data["profile_path"] as? String
        } else {
            self.profilePicPath = nil
        }
    }
}
