//
//  FollowFbFriendsViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 11/11/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FollowFbFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var usersArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getFbFriends()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getFbFriends() {
        let parameters = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: parameters)
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest) { (connection, result, error) in
            if error != nil {
                let errorMessage = error?.localizedDescription
                //print("Follow Error: ", errorMessage)
            } else {
                print("Result: ", result)
                
                //searchUserInFirebase(email: "")
            }
        }
        
        connection.start()
    }
    
    func searchUserInFirebase(email: String) {
        print("In Search User Firebase Function")
        DataService.instance.userRef.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Snapshot Search: ", snapshot)
            self.usersArray.removeAll()
            let currentUserId = DataService.instance.currentUserID
            if snapshot.exists() {
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                for (i, userData) in  dictionary.values.enumerated() {
                    let key = Array(dictionary.keys)[i]
                    if key != currentUserId {
                        let user = User(id: key, data: userData as! [String : AnyObject])
                        self.usersArray.append(user)
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        cell.configureCell(userData: usersArray[indexPath.row])
        return cell
    }
}
