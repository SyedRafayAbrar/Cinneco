//
//  UserProfileViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 22/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUserProfile()
    }
    
    
    
    
    
    func setupUserProfile() {
        //Check if user exists in Following list
    DataService.instance.currentUserRef.child("following").child(user.getId).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Follow Snapshot: ", snapshot)
            if snapshot.exists() {
                self.followBtn.setTitle("Unfollow", for: .normal)
            } else {
                self.followBtn.setTitle("Follow", for: .normal)
            }
        })
        
        if let profileImgUrl = user.getProfileImgurl {
            
            print(profileImgUrl)
            
            let imgUrl = URL(string: profileImgUrl)
            self.profileImgView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.profileImgView.image = #imageLiteral(resourceName: "sampleProfile")
        }
        
        if let followingCount = user.getFollowing {
            followingLbl.text = "\(followingCount)"
        } else {
            followingLbl.text = "0"
        }
        
        if let followerCount = user.getFollower {
            followersLbl.text = "\(followerCount.count)"
        } else {
            followersLbl.text = "0"
        }
    }
    
    @IBAction func followBtnAction(_ sender: UIButton) {
        let userId = user.getId
        let currentUserId = DataService.instance.currentUserID
        
        if sender.titleLabel?.text == "Follow" {
            //Adding user in current-user following-ref
            DataService.instance.currentUserFollowingRef.updateChildValues([userId: true], withCompletionBlock: { (errro, ref) in
                //Adding user in followed-user follower-ref
                DataService.instance.userRef.child(userId).child("follower").updateChildValues([currentUserId: true], withCompletionBlock: { (error, ref) in
                    //Update follower/following count in profile
                    DataService.instance.userRef.child(userId).child("follower").observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dictionary = snapshot.value as? [String: AnyObject] else {
                            return
                        }
                        let followerText = "\(dictionary.values.count)"
                        self.followersLbl.text = followerText
                        sender.setTitle("Unfollow", for: .normal)
                    })
                })
            })
        } else if sender.titleLabel?.text == "Unfollow" {
            //Removing user from current-user following-ref
            DataService.instance.currentUserFollowingRef.child(userId).removeValue(completionBlock: { (error, ref) in
                //Removing user from followed-user follower-ref
                DataService.instance.userRef.child(userId).child("follower").child(currentUserId).removeValue(completionBlock: { (error, ref) in
                    DataService.instance.userRef.child(userId).child("follower").observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dictionary = snapshot.value as? [String: AnyObject] else {
                            return
                        }
                        let followerText = "\(dictionary.values.count)"
                        self.followersLbl.text = followerText
                        sender.setTitle("Follow", for: .normal)
                    })
                })
            })
        }
    }
    
    @IBAction func followButtonAction(_ sender: UIButton) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailCell") as! UserProfileTableViewCell
            cell.configureCell(userData: user)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell")
            return cell!
        }
    }
    
}
