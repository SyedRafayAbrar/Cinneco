//
//  HomeViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 30/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import PageMenu
import Alamofire
import Firebase

class HomeViewController: UIViewController {
    
//    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    //    weak var delegate: FeedViewControllerDelegate? = nil
    var genreToPass: Genre!
    var movieId: String!
    var movieArray = [Movie]()
    //var keysArray = [String]()
    var indexPathArray = [IndexPath]()
    var pageNumber = 1
    var isLoading = false
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var pageMenuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var button_index = 0
    
    @IBOutlet weak var feedBtnLbl: UIButton!
    @IBOutlet weak var friendsBtnLbl: UIButton!
    
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    //    @IBOutlet weak var searchBar: UISearchBar!
    var pageMenu: CAPSPageMenu?
    
    fileprivate func UnderlineBtnWithColor() {
        var newlineView = UIView(frame: CGRect(x: 0, y: feedBtnLbl.frame.size.height, width: feedBtnLbl.frame.size.width, height: 2))

        newlineView.tag = 102

        newlineView.backgroundColor = BLUE_COLOR
        if (self.view.viewWithTag(102) == nil){
            feedBtnLbl.addSubview(newlineView)
            feedBtnLbl.setTitleColor(BLUE_COLOR, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        UnderlineBtnWithColor()
        
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        //To keep tableview above tab bar.
        //tableViewHeight.constant = tableViewHeight.constant - 49
        
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        getPopularMovies(page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        self.view.layoutIfNeeded()
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.backgroundColor = UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.0)
        
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
        
//        UnderlineBtnWithColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getPopularMovies(page: Int) {
        self.startSpinner()
        //        spinner_view.startAnimating()
        let popularMoviesUrl = POPULAR_MOVIES_URL + "\(page)"
        
        print(popularMoviesUrl)
        var count  = 0
        Alamofire.request(popularMoviesUrl).responseJSON { response in
            print("r: ", response)
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["results"] as? NSArray {
                    for value in valueArray {
                        let data = value as! [String: AnyObject]
                        let movie = Movie(data: data)
                        
                        //Checking in firebase if movie exists
                        
                        //                        DataService.instance.currentUserWatchedRef.child("\(movie.getId)").observeSingleEvent(of: ., with: { (snapshot) in
                        //
                        //                        })
                        
                        DataService.instance.currentUserWatchListRef.child("\(movie.getId)").observeSingleEvent(of: .value, with: { (snapshot) in
                            if !(snapshot.exists()) {
                                
                                DataService.instance.currentUserWatchedRef.child("\(movie.getId)").observeSingleEvent(of: .value, with: { (snapshot) in
                                    if !(snapshot.exists()) {
                                        
                                        
                                        self.movieArray.append(movie)
                                        
                                        //                                        self.tableView.dataSource = self
                                        //                                        self.tableView.delegate = self
                                        //
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                            self.tableView.reloadData()
                                        })
                                        
                                        //
                                        count = count + 1
                                        print("Count: \(count)")
                                        
                                        self.stopSpinner()
                                        self.isLoading = false
                                        
                                        print("DataSource \(self.tableView.dataSource.debugDescription)")
                                        
                                        
                                        print(movie.getTitle)
                                        
                                        print(self.movieArray.count)
                                        
                                        
                                        DispatchQueue.main.async {
                                            //                                           self.tableView.reloadData()
                                        }
                                    }
                                })
                            }
                        })
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 30.0, execute: {
                        //                        self.tableView.reloadData()
                    })
                } else {
                    self.stopSpinner()
                }
            } else{
                self.stopSpinner()
            }
        }
    }
    
    
    
    //    var newLine =
    @IBAction func feedBtnActn(_ sender: Any) {
        button_index = 0
        //        reviews.removeAll()
        //        getReviews(movieId: SELECTED_MOVIE.getId)
        var newlineView = UIView(frame: CGRect(x: 0, y: feedBtnLbl.frame.size.height, width: feedBtnLbl.frame.size.width, height: 2))
        
        newlineView.tag = 102
        
        newlineView.backgroundColor = BLUE_COLOR
        
        
        if (self.view.viewWithTag(102) == nil){
            feedBtnLbl.addSubview(newlineView)
            feedBtnLbl.setTitleColor(BLUE_COLOR, for: .normal)
        }
        if let viewWithTag = self.view.viewWithTag(103) {
            //            println("Tag 100")
            friendsBtnLbl.setTitleColor(UIColor.white, for: .normal)
            viewWithTag.removeFromSuperview()
        }
        
        //        self.communityTableView.reloadData()
        
        tableView.reloadData()
    }
    
    @IBAction func friendsBtnActn(_ sender: Any) {
        button_index = 1
        var newlineView = UIView(frame: CGRect(x: 0, y: friendsBtnLbl.frame.size.height, width: friendsBtnLbl.frame.size.width, height: 2))
        
        newlineView.tag = 103
        
        newlineView.backgroundColor = BLUE_COLOR
        
        
        if (self.view.viewWithTag(103) == nil){
            friendsBtnLbl.setTitleColor(BLUE_COLOR, for: .normal)
            friendsBtnLbl.addSubview(newlineView)
        }
        
        if let viewWithTag = self.view.viewWithTag(102) {
            feedBtnLbl.setTitleColor(UIColor.white, for: .normal)
            viewWithTag.removeFromSuperview()
        }
        
        tableView.reloadData()
        
        
    }
    
    func removeFromActivityLog() {
        //Remove activity in current user activity-log
        
        //Remove activity in all followers of current user news feed
    }
    
//    func startSpinner(spinner: UIActivityIndicatorView, button: UIButton) {
//        button.isHidden = true
//        spinner.isHidden = false
//        spinner.startAnimating()
//    }
    
//    func stopSpinner(spinner: UIActivityIndicatorView, button: UIButton) {
//        spinner.isHidden = true
//        spinner.stopAnimating()
//        button.isHidden = false
//    }
    
    func startSpinner() {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
    }

    func stopSpinner() {
        activitySpinner.isHidden = true
        activitySpinner.stopAnimating()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("INSIDE DID END")
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 0 {
            //print("End TV")
            if (!self.isLoading) {
                print("is loading")
                self.isLoading = true
                self.pageNumber = pageNumber + 1
                print("Page Number: \(self.pageNumber)")
                //load new data
                getPopularMovies(page: self.pageNumber)
                
            }
        }
    }
    
}




//extension HomeViewController: FeedViewControllerDelegate {
//
//    func didTapCellAtIndexPathFeed(indexPath: IndexPath) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "reviewViewController") as! ReviewViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//}

//extension HomeViewController : FriendViewControllerDelegate {
//    func didTapCellAtIndexPathFriends(indexPath: IndexPath) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "reviewViewController") as! ReviewViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.section == 1 {
        //            return 133.0
        //        }
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if button_index == 1 {
            return 10
        } else{
            print("Movie Array: \(self.movieArray.count)")
            
            return self.movieArray.count
        }
        //        if section == 0 {
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if button_index == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendTableViewCell
            //        cell.configureCell(movieData: movieArray[indexPath.row])
            
            return cell
        } else {
            
            
            
            //        if indexPath.section == 1 {
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreFriends", for: indexPath)
            //            return cell
            //        }
            //        else {
            
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
            //        let l = cell.viewWithTag(99) as! UILabel
            //        l.text = "ABC XYZ"
            
            //        let x = cell.viewWithTag(88) as! UILabel
            //        x.text = "Starring: Daisy Riddle"
            
            if (cell == nil) {
                //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
                //            print("No Cell")
            }else {
                print("No cell")
            }
            cell.configureCell(movieData: movieArray[indexPath.row])
            
            
            //        print("Index Path \(indexPath.row) & Movie Array Count \(self.movieArray.count)")
            //            if indexPath.row == self.movieArray.count - 1 {
            //                self.loadMore()
            //            }
            
            //        if !(indexPathArray.isEmpty) && indexPathArray.contains(indexPath){
            //            let cellBtn = cell.viewWithTag(100) as! UIButton
            //            cellBtn.backgroundColor = UIColor.black
            //            cellBtn.setTitle("Remove", for: .normal)
            //
            //        }
            
            return cell
            //        }
        }
        
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SELECTED_MOVIE = movieArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func addToWatchlistAction(_ sender: UIButton) {
        
        if let cell = sender.superview?.superview?.superview as? FeedTableViewCell {
            
            if let movieReference = cell.movie {
                self.movieId = "\(movieReference.getId)"
                
                let indexPath = tableView.indexPath(for: cell)
                let cellBtn = cell.viewWithTag(100) as! UIButton
                //                let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
                //                startSpinner(spinner: spinner, button: cellBtn)
                
                if sender.titleLabel?.text == "Add to Watchlist" {
                    DataService.instance.currentUserWatchListRef.updateChildValues([movieId: "true"])
                    cellBtn.backgroundColor = UIColor.black
                    cellBtn.setTitle("Remove", for: .normal)
                    self.indexPathArray.append(indexPath!)
                    //                    self.stopSpinner(spinner: spinner, button: cellBtn)
                    //FEED_ACTION = "Added to Watchlist"
                    
                    //Call func to ADD this to followers Feed
                    if UserDefaults.standard.object(forKey: "USERNAME") != nil {
                        let username = UserDefaults.standard.string(forKey: "USERNAME")!
                        addToActivityLog(action: "\(username) Added to Watchlist", cell: cell)
                    }
                    //addToActivityLog(action: "Added to Watchlist", cell: cell)
                    
                } else {
                    //DataService.instance.currentUserFollowerRef.removeAllObservers()
                    //DataService.instance.userRef.removeAllObservers()
                    let toRemove = indexPathArray.index(of: indexPath!)
                    indexPathArray.remove(at: toRemove!)
                    cellBtn.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
                    cellBtn.setTitle("Add to Watchlist", for: .normal)
                    DataService.instance.currentUserWatchListRef.child(movieId).removeValue()
                    //                    stopSpinner(spinner: spinner, button: cellBtn)
                    
                    //Call func to REMOVE this from followers Feed
                }
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
    
    
    
}


