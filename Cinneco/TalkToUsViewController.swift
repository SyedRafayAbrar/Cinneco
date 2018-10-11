//
//  TalkToUsViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 21/05/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit

class TalkToUsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension TalkToUsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toCell", for: indexPath)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ccCell", for: indexPath)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath)
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath)
            return cell
        }
        
        return cell
        
        
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.row == 3 {
//            return 280.0
//        }
//        else {
//            return 200
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 180.0
        }
        else {
            return 37.0
        }
    }
    
    
}
