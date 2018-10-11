//
//  DataService.swift
//  Cinneco
//
//  Created by Asher Ahsan on 26/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    let ref = Database.database().reference()
    let userRef = Database.database().reference().child("users")
    let movieRef = Database.database().reference().child("movies")
    let activityLogRef = Database.database().reference().child("activityLog")
    let newsFeedRef = Database.database().reference().child("newsFeed")
    let storageRef = Storage.storage().reference()
    
    var currentUserID: String {
        let uid = Auth.auth().currentUser?.uid
        return uid!
    }
    
    var currentUserRef: DatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "UID") as! String
        let user = userRef.child(uid)
        return user
    }
    
    var currentUserActivityLogRef: DatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "UID") as! String
        let logRef = activityLogRef.child(uid)
        return logRef
    }
    
    var currentUserNewsFeedRef: DatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "UID") as! String
        let feedRef = newsFeedRef.child(uid)
        return feedRef
    }
    
    var currentUserFollowingRef: DatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "UID") as! String
        let followingRef = userRef.child(uid).child("following")
        return followingRef
    }
    
    var currentUserFollowerRef: DatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "UID") as! String
        let followerRef = userRef.child(uid).child("follower")
        return followerRef
    }
    
    var currentUserWatchedRef: DatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "UID") as! String
        let watchedRef = userRef.child(uid).child("watched")
        return watchedRef
    }
    
    var currentUserWatchListRef: DatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "UID") as! String
        let watchListRef = userRef.child(uid).child("watchList")
        return watchListRef
    }
    
//    var currentUserActivityLogRef: FIRDatabaseReference {
//        let uid = UserDefaults.standard.value(forKey: "UID") as! String
//        let activityLogRef = userRef.child(uid).child("activityLog")
//        return activityLogRef
//    }
}
