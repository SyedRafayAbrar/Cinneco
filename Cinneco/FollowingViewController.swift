//
//  FollowingViewController.swift
//  Cinneco
//
//  Created by TAMUR on 26/04/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import Kingfisher

class FollowingViewController: UIViewController {

    
    var followingList = [Followers]()
    var folowersIDList:[String] = []
    @IBOutlet weak var tableView: UITableView!
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        let uid = DataService.instance.currentUserID
        
        DataService.instance.currentUserFollowingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print("Follow Snapshot: ", snapshot.key)
            
            if !(snapshot.exists()){
                if let dict = snapshot.key as? String{
                   
                        
                         self.folowersIDList.append(dict)
                        
                    DataService.instance.userRef.child(dict).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dictionary = snapshot.value as? [String: AnyObject] else {
                            return
                        }
                        print("Dict: ", dictionary)
                        
                        print("Snap: ", snapshot)
                        var follower:Followers!
                        follower = Followers(id: dict, data: dictionary)
                        
                        self.followingList.append(follower)
                        
                        //                    self.tableView.dataSource = self
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        
                    })
                    
                   
                    
                }
            }
            print(snapshot)
        })
        if folowersIDList.count != 0 {
        
            for i in folowersIDList{
            
            
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

func getFollowers(){
    
}

extension FollowingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folowersIDList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersCell", for: indexPath) as! FollowersTableViewCell
        
        cell.follower_image.layer.cornerRadius = cell.follower_image.frame.size.width/2
        
        cell.follower_image.clipsToBounds = true
        if let urlStr = followingList[indexPath.row].getProfileImgurl as? String{
            let url = URL(string: urlStr)
            cell.follower_image.kf.setImage(with: url)
        }
        
        cell.follower_name.text = followingList[indexPath.row].getFullname
        cell.follower_hastag.text = followingList[indexPath.row].getUsername
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}


