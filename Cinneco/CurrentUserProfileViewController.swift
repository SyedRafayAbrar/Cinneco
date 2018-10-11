//
//  CurrentUserProfileViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 28/10/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import PageMenu
import Alamofire

class CurrentUserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var pageMenuView: UIView!
    @IBOutlet weak var WatchedBtnOutlet: UIButton!
    @IBOutlet weak var WatchListBtnOutlet: UIButton!
    
    
//    var pageMenu: CAPSPageMenu?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
   
    
    var currentUser: User!
    
    var watchedMoviesArray = [Movie]()
    var watchlistMoviesArray = [Movie]()
    var movieData: Movie!
    
    var button_index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
//        getCurrentUser()
        
        tableView.tableFooterView = UIView()
        
        getWatchedMovies()
        getWatchlistMovies()
        
        UnderlineBtnWithColor() 
        
//        profileImgView.layer.borderWidth = 1
//        profileImgView.layer.masksToBounds = false
//        profileImgView.layer.borderColor = UIColor.black.cgColor
       
        
//        cell.follower_image.layer.cornerRadius = cell.follower_image.frame.size.width/2
//
//        cell.follower_image.clipsToBounds = true
//        UnderlineBtnWithColor()
        
     
    }
    fileprivate func UnderlineBtnWithColor() {
        //        self.navigationController?.navigationBar.isTranslucent = true
        //        self.automaticallyAdjustsScrollViewInsets = false
        
        
        var newlineView = UIView(frame: CGRect(x: 0, y: WatchedBtnOutlet.frame.size.height, width: WatchedBtnOutlet.frame.size.width, height: 2))
        
        newlineView.tag = 31
//
        newlineView.backgroundColor = BLUE_COLOR
//
        
        if (self.view.viewWithTag(31) == nil){
            WatchedBtnOutlet.addSubview(newlineView)
            WatchedBtnOutlet.setTitleColor(BLUE_COLOR, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCurrentUser()
    }
    
    override func viewDidLayoutSubviews() {
//        UnderlineBtnWithColor()
        
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        profileImgView.clipsToBounds = true
    }
    
    func getWatchlistMovies() {
        //startSpinner(spinner: spinner2, collectionView: watchlistCollectionView)
        //        startSpinner(spinner: spinner2, carousel: watchlistCarousel)
        //        self.watchedMoviesArray.removeAll()
        self.watchlistMoviesArray.removeAll()
        
        //self.activitySpinner2.startAnimating()
        DataService.instance.currentUserWatchListRef.observe(.childAdded, with: { (snapshot) in
            let movieId = snapshot.key
            let movieRef = DataService.instance.movieRef.child(movieId)
            
            let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(MOVIEDB_API_KEY)&language=en-US"
            
            Alamofire.request(url).responseJSON { response in
                if let value = response.result.value as? [String: AnyObject] {
                    let data = value as! [String: AnyObject]
                    let movie = Movie(data: data)
                    self.watchlistMoviesArray.append(movie)
                    self.tableView.reloadData()
                    //                    self.watchlistCarousel.reloadData()
                    //                    self.stopSpinner(spinner: self.spinner2, carousel: self.watchedCarousel)
                }
            }
            //            movieRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //                guard let dictionary = snapshot.value as? [String: AnyObject] else {
            //                    return
            //                }
            //                let movie = Movie(data: dictionary)
            //                self.watchlistMoviesArray.append(movie)
            //                self.stopSpinner(spinner: self.spinner2, carousel: self.watchedCarousel)
            //
            //                self.watchlistCarousel.reloadData()
            ////                self.watchlistCollectionView.reloadData()
            //                //self.spinner2.stopAnimating()
            //            })
            
        })
    }
    
    func getWatchedMovies() {
        
        //self.watchlistMoviesArray.removeAll()
        //        self.watchedMoviesArray.removeAll()
        DataService.instance.currentUserWatchedRef.observe(.childAdded, with: { (snapshot) in
            //            self.startSpinner(spinner: self.spinner1, carousel: self.watchedCarousel)
            let movieId = snapshot.key
            let movieRef = DataService.instance.movieRef.child(movieId)
            
            let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(MOVIEDB_API_KEY)&language=en-US"
            
            Alamofire.request(url).responseJSON { response in
                if let value = response.result.value as? [String: AnyObject] {
                    //                    self.watchedMoviesArray.removeAll()
                    
                    let data = value as! [String: AnyObject]
                    let movie = Movie(data: data)
                    self.watchedMoviesArray.append(movie)
                    //                    self.tableView.reloadData()
                    //                    print("Watched Movie Name: \(movie.getTitle)")
                    //
                    //                    print("API Call Count \(self.watchedMoviesArray.count)")
                    
                    //                    self.stopSpinner(spinner: self.spinner1, carousel: self.watchedCarousel)
                    //                    self.watchedCarousel.reloadData()
                    
                    //                    if !self.watchedMoviesArray.isEmpty  // if your array is not empty refresh the tableview
                    //                    {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    //                        self.tableView.reloadData()
                    //                    })
                    //                    }
                    
                    
                }
            }
        })
        
    }
    
    func getCurrentUser() {
        
        DataService.instance.currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            print("Dict: ", dictionary)
            
            print("Snap: ", snapshot)
            
            self.currentUser = User(id: snapshot.key, data: dictionary)
            
            print(self.currentUser.getFullname)
            
            print(self.currentUser.getDescription)
            
            self.setupUserProfile(user: self.currentUser)
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
    }
    
    func setupUserProfile(user: User) {
        if let profileImgUrl = user.getProfileImgurl {
            let imgUrl = URL(string: profileImgUrl)
            self.profileImgView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.profileImgView.image = #imageLiteral(resourceName: "profile-ph")
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 200
//        } else {
//            return 200
//        }
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return UITableViewAutomaticDimension
//        } else {
//            return 200
//        }
//    }
    
    
    @IBAction func WatchedBtnActn(_ sender: Any) {
        button_index = 0
        //        reviews.removeAll()
        
        //        getReviews(movieId: SELECTED_MOVIE.getId)
        
//        var newlineView = UIView()
        var newlineView = UIView(frame: CGRect(x: 0, y: WatchedBtnOutlet.frame.size.height, width: WatchedBtnOutlet.frame.size.width, height: 2))
        newlineView.tag = 31
        newlineView.backgroundColor = BLUE_COLOR
        if (self.view.viewWithTag(31) == nil){
            WatchedBtnOutlet.setTitleColor(BLUE_COLOR, for: .normal)
            WatchedBtnOutlet.addSubview(newlineView)
            
        }
        if let viewWithTag = self.view.viewWithTag(32) {
            WatchListBtnOutlet.setTitleColor(UIColor.white, for: .normal)
            viewWithTag.removeFromSuperview()
        }
        
        //        self.communityTableView.reloadData()
        
        tableView.reloadData()
    
    }
    
    @IBAction func WatchListBtnActn(_ sender: Any) {
        button_index = 1
//        var newlineView = UIView()
        var newlineView  = UIView(frame: CGRect(x: 0, y: WatchListBtnOutlet.frame.size.height, width: WatchListBtnOutlet.frame.size.width, height: 2))
        newlineView.tag = 32
        newlineView.backgroundColor = BLUE_COLOR
        if (self.view.viewWithTag(32) == nil) {
            WatchListBtnOutlet.setTitleColor(BLUE_COLOR, for: .normal)
            WatchListBtnOutlet.addSubview(newlineView)
        }
        
        if let viewWithTag = self.view.viewWithTag(31) {
            WatchedBtnOutlet.setTitleColor(UIColor.white, for: .normal)
            viewWithTag.removeFromSuperview()
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if indexPath.row == 1 {
//            return 500.0
//        }
        
        return 125
        
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else {
//            return 0
//        }
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if !self.watchedMoviesArray.isEmpty  // if your array is not empty refresh the tableview
        //        {
        if button_index == 0 {
            print("Watched Movie Count \(watchedMoviesArray.count)")
            return watchedMoviesArray.count
        }
        else {
             return watchlistMoviesArray.count
        }
    
        
        return 1
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if button_index == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserWatchedCell") as! GeneralMovieTableViewCell
            
            print("Index Path: \(indexPath.row)")
            //        print(watchedMoviesArray[indexPath.row].getOriginalName)
            
            //        cell.configureCell(movieData: moviesArray[indexPath.row])
            cell.configureCell(movieData: watchedMoviesArray[indexPath.row])
            return cell
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserWatchListCell") as! GeneralMovieTableViewCell
            //        cell.configureCell(movieData: moviesArray[indexPath.row])
            cell.configureCell(movieData: watchlistMoviesArray[indexPath.row])
            return cell
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return  138
//    }
    
    
}
