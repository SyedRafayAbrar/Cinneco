//
//  FeedViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 31/08/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

//protocol FeedViewControllerDelegate: class {
//    func didTapCellAtIndexPathFeed(indexPath: IndexPath)
//}

protocol FeedViewControllerDelegate: class {
    func didTapCellAtIndexPathFeed(indexPath: IndexPath)
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
//        @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    //    weak var delegate: FeedViewControllerDelegate? = nil
    var genreToPass: Genre!
    var movieId: String!
    var movieArray = [Movie]()
    //var keysArray = [String]()
    var indexPathArray = [IndexPath]()
    var pageNumber = 1
    var isLoading = false
    
    //    var count = 0
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        //To keep tableview above tab bar.
        //tableViewHeight.constant = tableViewHeight.constant - 49
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        tableView.contentInset.top = -44
//        tableHeaderView = nil
//        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
//        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.section == 1 {
        //            return 133.0
        //        }
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if section == 0 {
        print("Movie Array: \(self.movieArray.count)")
        
        return self.movieArray.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    //
    //    func loadMore() {
    //        self.pageNumber = pageNumber + 1
    //        print("Page Number: \(self.pageNumber)")
    //        getPopularMovies(page: self.pageNumber)
    //        //        DispatchQueue.main.async {
    //        //            self.tableView.reloadData()
    //        //        }
    //    }
    //
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SELECTED_MOVIE = movieArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IndividualMovieController")
        self.present(controller, animated: true, completion: nil)
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        delegate?.didTapCellAtIndexPathFeed(indexPath: indexPath)
    //
    //    }
    
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
    
    func removeFromActivityLog() {
        //Remove activity in current user activity-log
        
        //Remove activity in all followers of current user news feed
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
    
    
    @IBAction func GenerePressed(_ sender: Any) {
        
        //        genreToPass = cell.genre
        //        self.performSegue(withIdentifier: "genreSegueN", sender: self)
        //    }
        //
        //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "genreSegueN" {
        //            let destVc = segue.destination as! GenreViewController
        //            destVc.genre =
    }
    
    func startSpinner() {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
    }
    
    func stopSpinner() {
        activitySpinner.isHidden = true
        activitySpinner.stopAnimating()
    }
    
    
}

