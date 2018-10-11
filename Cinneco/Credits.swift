//
//  Credits.swift
//  Cinneco
//
//  Created by Asher Ahsan on 09/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation

class Credits {
    private var id: Int!
    private var castId: Int!
    private var character: String?
    private var gender: String!
    private var name: String!
    private var order: Int!
    private var profilePath: String?
    private var job: String?
    private var department: String?
    
    var getId: Int {
        return self.id
    }
    
    var getCastId: Int {
        return self.castId
    }
    
    var getCharacter: String? {
        return self.character
    }
    
    var getGender: String? {
        return self.gender
    }
    
    var getName: String {
        return self.name
    }
    
    var getOrder: Int {
        return self.order
    }
    
    var getProfilePath: String? {
        return self.profilePath
    }
    
    var getJob: String? {
        return self.job
    }
    
    var getDepartment: String? {
        return self.department
    }
    
    init(data: [String: AnyObject]) {
        if data["id"] != nil {
            self.id = data["id"] as! Int
        } else {
            self.id = nil
        }
        
        if data["cast_id"] != nil {
            self.castId = data["cast_id"] as! Int
        } else {
            self.castId = nil
        }
        
        if data["character"] != nil {
            self.character = data["character"] as? String
        } else {
            self.character = nil
        }
        
        if data["gender"] != nil {
            var gender = data["gender"] as! Int
            if gender == 1 {
                self.gender = "female"
            } else {
                self.gender = "male"
            }
        } else {
            self.gender = nil
        }
        
        if data["name"] != nil {
            self.name = data["name"] as! String
        } else {
            self.name = nil
        }
        
        if data["order"] != nil {
            self.order = data["order"] as! Int
        } else {
            self.order = nil
        }
        
        if data["profile_path"] != nil {
            self.profilePath = data["profile_path"] as? String
        } else {
            self.profilePath = nil
        }
        
        if data["job"] != nil {
            self.job = data["job"] as? String
        } else {
            self.job = nil
        }
        
        if data["department"] != nil {
            self.department = data["department"] as? String
        } else {
            self.department = nil
        }
    }
}
