//
//  SettingsTableViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 09/07/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKShareKit

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func logoutAction() {
        print("Logout")
        UserDefaults.standard.removeObject(forKey: "UID")
        
        try! Auth.auth().signOut()
        
        //Back to login screen
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginViewController")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 13
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 12:
                logoutAction()
            default:
                break
            }
            
        }
        
    }
}
