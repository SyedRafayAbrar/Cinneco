//
//  User.swift
//  Cinneco
//
//  Created by Asher Ahsan on 22/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation

class User {
    private var id: String!
    private var username: String!
    private var fullname: String!
    private var email: String!
    private var profileImgUrl: String?
    private var description: String?
    private var website: String?
    private var location: String?
    private var follower: [String]?
    private var following: [String]?
    private var watched: [String]?
    private var watchlist: [String]?
    
    var getId: String {
        return self.id
    }
    
    var getUsername: String {
        return self.username
    }
    
    var getFullname: String {
        return self.fullname
    }
    
    var getEmail: String {
        return self.email
    }
    
    var getProfileImgurl: String? {
        return self.profileImgUrl
    }
    
    var getFollower: [String]? {
        return self.follower
    }
    
    var getFollowing: [String]? {
        return self.following
    }
    
    var getWatched: [String]? {
        return self.watched
    }
    
    var getWatchlist: [String]? {
        return self.watchlist
    }
    
    var getDescription: String? {
        return self.description
    }
    
    var getWebsite: String? {
        return self.website
    }
    
    var getLocation: String? {
        return self.location
    }
    
    init(id: String, data: [String: AnyObject]) {
        self.id = id
        
        if data["username"] != nil {
            self.username = data["username"] as! String
        } else {
            self.username = nil
        }
        
        if data["fullName"] != nil {
            self.fullname = data["fullName"] as! String
        } else {
            self.fullname = nil
        }
        
        if data["email"] != nil {
            self.email = data["email"] as! String
        } else {
            self.email = nil
        }
        
        if data["imageURL"] != nil {
            self.profileImgUrl = data["imageURL"] as? String
        } else {
            self.profileImgUrl = nil
        }
        
        if data["follower"] != nil {
            self.follower = data["follower"] as? [String]
        } else {
            self.follower = nil
        }
        
        if data["following"] != nil {
            self.following = data["following"] as? [String]
        } else {
            self.following = nil
        }
        
        if data["watched"] != nil {
            let dictionary = data["watched"] as! [String: AnyObject]
            self.watched = Array(dictionary.keys)
        } else {
            self.watched = nil
        }
        
        if data["watchList"] != nil {
            let dictionary = data["watchList"] as! [String: AnyObject]
            self.watchlist = Array(dictionary.keys)
        } else {
            self.watchlist = nil
        }
        
        if data["description"] != nil {
            self.description = data["description"] as? String
        } else {
            self.description = "User doesn't have provided a description yet"
        }
        
        if data["website"] != nil {
            self.website = data["website"] as? String
        } else {
            self.website = nil
        }
        
        if data["location"] != nil {
            self.location = data["location"] as? String
        } else {
            self.location = nil
        }
    }
}
