//
//  Review.swift
//  Cinneco
//
//  Created by Asher Ahsan on 05/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation

class Review {
    private var author : String
    private var content : String
    private var id : String
    private var url : String
    
    var getAuthor : String {
        return self.author
    }
    
    var getContent: String {
        return self.content
    }
    
    var getId : String {
        return self.id
    }
    
    var getUrl : String {
        return self.getUrl
    }
    
    init(data: [String: AnyObject]) {
        if data["author"] != nil {
            self.author = (data["author"] as? String)!
        } else {
            self.author = "Author Not Avaliable"
        }
        
        if data["content"] != nil {
            self.content = (data["content"] as? String)!
        } else {
            self.content = "Content Not Avaliable"
        }
        
        if data["id"] != nil {
            self.id = (data["id"] as? String)!
        } else {
            self.id = "Id Not Avaliable"
        }
        
        if data["url"] != nil {
            self.url = (data["url"] as? String)!
        } else {
            self.url = "url Not Avaliable"
        }
    }
    
}
