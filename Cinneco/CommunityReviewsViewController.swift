//
//  CommunityReviewsViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 20/05/2018.
//  Copyright © 2018 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire

class CommunityReviewsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    //    var dataSourceArray = [1,2]
    var seeAllSectionArray = [1]
    var showMoreButtonTapped = false
    
    var communityReviews = [Review]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
//        getReviews(movieId:)
        
    }
    
   
    
    func reloadTableView() {
        
//        communityReviews.removeAll()
        print("Reviews Count: \(communityReviews.count)")
        
//        self.tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        if showMoreButtonTapped {
        //            return 1
        //        } else {
        //            return 2
        //        }
        return 1
    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if section == 0 {
        print(communityReviews.count)
        return communityReviews.count
        //        } else {
        //            return 1
        //        }
        
        /* if seeAllSectionArray.count > 0{
         if section == 0 {
         
         print(section)
         print(dataSourceArray.count) scrool q ni chalrha?
         
         return dataSourceArray.count
         }
         else if section == 1 {
         
         print(section)
         print(seeAllSectionArray.count)
         
         return seeAllSectionArray.count
         }
         }
         else {
         return dataSourceArray.count
         }
         return 0*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = UITableViewCell()
        
        // if seeAllSectionArray.count > 0 {
        
        //            if (indexPath.section == 0) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommRevCell", for: indexPath) as? CommunityReviewsTableViewCell
        cell?.follower_image.layer.cornerRadius = (cell?.follower_image.frame.size.width)!/2
        cell?.follower_image.clipsToBounds = true
        cell?.author_name.text = communityReviews[indexPath.row].getAuthor
        return cell!
        
        
        //            }
        
        //            else {
        //                let cell = tableView.dequeueReusableCell(withIdentifier: "seeAllStaticCell", for: indexPath) as? CommunityReviewsSeeAllCell
        //
        //
        //                cell?.seeAllStaticCell.addTarget(self, action: #selector(CommunityReviewsViewController.seeAllPressed(_:)), for: .touchUpInside)
        //                return cell!
        //
        //            }
        
        //}kia hua?chala?
        //        See All wala cell kaha gya? acha wo pehli bar me h show ni hua?
        //Nae huwa show. set
        /*  else {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "CommRevCell", for: indexPath) as! CommunityReviewsTableViewCell
         cell.follower_image.layer.cornerRadius = cell.follower_image.frame.size.width/2
         cell.follower_image.clipsToBounds = true
         return cell
         }*/
        
        
        //        return cell
        
    }
    
    //    func seeAllPressed(_ sender: Any?) {
    //        dataSourceArray.removeAll()
    //        seeAllSectionArray.removeAll()
    //
    ////        DispatchQueue.main.async {
    ////            self.tableView.reloadData()
    ////            self.tableView.layoutSubviews()
    ////        }
    //
    //        dataSourceArray.append(3)
    //        dataSourceArray.append(3)
    //        dataSourceArray.append(3)
    //        dataSourceArray.append(3)
    //        dataSourceArray.append(3)
    //
    //        showMoreButtonTapped = !showMoreButtonTapped
    //
    //
    //        //        dataSourceArray.removeAll()
    //
    //        print(dataSourceArray)
    //        print(seeAllSectionArray)
    //
    //        DispatchQueue.main.async {
    //            self.tableView.reloadData()
    //            self.tableView.layoutSubviews()
    //        }
    //    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 147
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.section == 0 {
        return 155
        //        }
        //        else if indexPath.section == 1 {
        //            return 25
        //        }
        //        else {
        //            return 0
        //        }
    }
    
}

