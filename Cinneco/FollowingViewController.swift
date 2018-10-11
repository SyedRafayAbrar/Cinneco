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

class FollowingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        DataService.instance.currentUserRef.child("following").child(user.getId).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Follow Snapshot: ", snapshot)
snapshot.exists()
            print(snapshot)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension FollowingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersCell", for: indexPath) as! FollowersTableViewCell
        
        cell.follower_image.layer.cornerRadius = cell.follower_image.frame.size.width/2
        
        cell.follower_image.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}


