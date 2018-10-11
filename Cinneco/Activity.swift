//
//  Activity.swift
//  Cinneco
//
//  Created by Asher Ahsan on 29/11/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation

class Activity {
    private var id: String!
    private var ownerId: String!
    private var timestamp: String!
    private var movieId: String!
    private var action: String!
    
    var getId: String {
        return self.id
    }
    
    var getOwnerId: String {
        return self.ownerId
    }
    
    var getTimestamp: String {
        return self.timestamp
    }
    
    var getMovieId: String {
        return self.movieId
    }
    
    var getAction: String {
        return self.action
    }
    
    init(id: String, activityDetail: [String: AnyObject]) {
        print("Activity Detail: ", activityDetail)
        self.id = id
        self.ownerId = activityDetail["ownerId"] as? String
        self.timestamp = activityDetail["timestamp"] as? String
        self.action = activityDetail["action"] as? String
        self.movieId = activityDetail["movieId"] as? String
    }
    
    
}
