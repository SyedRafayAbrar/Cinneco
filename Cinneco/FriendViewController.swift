//
//  FriendViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 31/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire
//import SHSearchBar
import Firebase

protocol FriendViewControllerDelegate: class {
    func didTapCellAtIndexPathFriends(indexPath: IndexPath)
}

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate : FriendViewControllerDelegate? = nil
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var newsFeedTableView: UITableView!
    
    @IBOutlet weak var friendsTableView : UITableView!
    
    var movieId: String!
    var movieArray = [Movie]()
    var activityArray = [Activity]()
    var indexPathArray = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableViewHeight.constant = tableViewHeight.constant - 49
        
//        newsFeedTableView.delegate = self
//        newsFeedTableView.dataSource = self
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        //Get posts from current-user FriendsFeed
        getNewsFeed()
    }
    
    func getNewsFeed() {
        DataService.instance.currentUserNewsFeedRef.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            for (key, value) in dictionary {
                let activity = Activity(id: key, activityDetail: value as! [String : AnyObject])
                self.activityArray.append(activity)
            }
            
            self.activityArray = self.activityArray.sorted(by: { $0.getTimestamp < $1.getTimestamp })
            self.getMovies()
        })
    }
    
    func getMovies() {
        for activity in activityArray {
            let url = "https://api.themoviedb.org/3/movie/\(activity.getMovieId)?api_key=\(MOVIEDB_API_KEY)&language=en-US"
            //print("Activity ID: ", activity.getId)
            //print("Activity Time: ", activity.getTimestamp)
            Alamofire.request(url).responseJSON { response in
                if let value = response.result.value as? [String: AnyObject] {
                    let movie = Movie(data: value)
                    self.movieArray.append(movie)
                    self.friendsTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addToWatchlistAction(_ sender: UIButton) {
        if let cell = sender.superview?.superview?.superview as? FeedTableViewCell {
            if let movieReference = cell.movie {
                self.movieId = "\(movieReference.getId)"
                
                let indexPath = friendsTableView.indexPath(for: cell)
                let cellBtn = cell.viewWithTag(100) as! UIButton
                let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
                startSpinner(spinner: spinner, button: cellBtn)
                
                if sender.titleLabel?.text == "Add to Watchlist" {
                    DataService.instance.currentUserWatchListRef.updateChildValues([movieId: "true"])
                    cellBtn.backgroundColor = UIColor.black
                    cellBtn.setTitle("Remove", for: .normal)
                    self.indexPathArray.append(indexPath!)
                    self.stopSpinner(spinner: spinner, button: cellBtn)
                    //FEED_ACTION = "Added to Watchlist"
                    
                    //Call func to ADD this to followers Feed
                    if UserDefaults.standard.object(forKey: "USERNAME") != nil {
                        let username = UserDefaults.standard.string(forKey: "USERNAME")!
                        addToActivityLog(action: "\(username) Added to Watchlist", cell: cell)
                    }
                    //addToActivityLog(action: "Added to Watchlist", cell: cell)
                    
                }/* else {
                    //DataService.instance.currentUserFollowerRef.removeAllObservers()
                    //DataService.instance.userRef.removeAllObservers()
                    let toRemove = indexPathArray.index(of: indexPath!)
                    indexPathArray.remove(at: toRemove!)
                    cellBtn.backgroundColor = UIColor(red: 120/255, green: 171/255, blue: 1, alpha: 1.0)
                    cellBtn.setTitle("Add to Watchlist", for: .normal)
                    DataService.instance.currentUserWatchListRef.child(movieId).removeValue()
                    //stopSpinner(spinner: spinner, button: cellBtn)
                    
                    //Call func to REMOVE this from followers Feed
                }*/
            }
        }
    }
    
    func addToActivityLog(action: String, cell: FeedTableViewCell) {
        //Add activity in current user activity-log
        let currentTime = Date().timeIntervalSince1970 * 1000
        //let cellBtn = cell.viewWithTag(100) as! UIButton
        //let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
        let currentUserId = DataService.instance.currentUserID
        let activityId = DataService.instance.currentUserActivityLogRef.childByAutoId()
        let activityDetail = ["ownerId": currentUserId,
                              "movieId": self.movieId,
                              "action":  action, //FEED_ACTION,
            "timestamp": "\(currentTime)"] as [String : Any]
        
        activityId.updateChildValues(activityDetail) { (error, ref) in
            if error != nil {
                print("Feed Error")
            } else {
                //Add activity in all followers of current user news feed
                /*
                 DataService.instance.currentUserFollowerRef.observe(.childAdded, with: { (snapshot) in
                 let followerId = snapshot.key
                 let followerRef = DataService.instance.userRef.child(followerId)
                 
                 followerRef.child("newsFeed").updateChildValues([activityId.key: true])
                 self.stopSpinner(spinner: spinner, button: cellBtn)
                 })*/
            }
        }
    }
    
    func startSpinner(spinner: UIActivityIndicatorView, button: UIButton) {
        button.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func stopSpinner(spinner: UIActivityIndicatorView, button: UIButton) {
        spinner.isHidden = true
        spinner.stopAnimating()
        button.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 1
        }
//        return self.movieArray.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 133.0
        }else {
             return 170
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreFriends", for: indexPath)
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendTableViewCell
            //        cell.configureCell(movieData: movieArray[indexPath.row])
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didTapCellAtIndexPathFriends(indexPath: indexPath)
        
//        let controller = storyboard?.instantiateViewController(withIdentifier: "reviewViewController")
//        self.present(controller!, animated: true, completion: nil)
        
//         self.performSegue(withIdentifier: "showReviews", sender: self)
    }
}
