//
//  Genre.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation

class Genre {
    private var id: Int!
    private var name: String!
    
    var getId: Int! {
        return self.id
    }
    
    var getName: String! {
        return self.name
    }

    init(data: [String: AnyObject]) {
        if data["id"] != nil {
            self.id = data["id"] as? Int
        } else {
            self.id = nil
        }
        
        if data["name"] != nil {
            self.name = data["name"] as? String
        } else {
            self.name = nil
        }
    }
}
