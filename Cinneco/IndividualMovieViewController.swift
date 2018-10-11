//
//  IndividualMovieViewController.swift
//  Cinneco
//
//  Created by Asher Ahsan on 30/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.

import UIKit
import Cosmos
import Alamofire
import Firebase
import PageMenu



class IndividualMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var NoReviewLbl: UILabel!
    @IBOutlet weak var communityReviewBtn: UIButton!
    @IBOutlet weak var friendsReviewBtn: UIButton!
    
    var button_index = 0
    
    var reviews = [Review]()
    
    @IBOutlet weak var communityTableView: UITableView!
    
    @IBOutlet weak var pageMenuView: UIView!
//    var pageMenu: CAPSPageMenu?
    
    var communityReviewVC = CommunityReviewsViewController()
    
    
//    var newlineView = UIView()
    
    @IBOutlet weak var background_image: UIImageView!
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backdropView: UIView! // tmdb api 1
    @IBOutlet weak var backdropImgView: UIImageView!
    @IBOutlet weak var moviePosterImgView: UIImageView! // tmdb api 1
    @IBOutlet weak var movieTitleLbl: UILabel! // tmdb api 1
    @IBOutlet weak var directorLbl: UILabel! // tmdb api 6
    
    @IBOutlet weak var avgRatingStarView: CosmosView! // tmdb api 1
    @IBOutlet weak var ratingLbl: UILabel! //vote avg + vote count tmdb api 1
    @IBOutlet weak var watchedBtn: UIButton! // firebase api
    @IBOutlet weak var myRatingStarView: CosmosView! // firebase api
    
    @IBOutlet weak var movieDescriptionLbl: UILabel! // tmdb api 1
    
    @IBOutlet weak var releaseDateLbl: UILabel! // tmdb api 1
    @IBOutlet weak var producerLbl: UILabel!
    @IBOutlet weak var productionCompanyLbl: UILabel! // tmdb api 1
    @IBOutlet weak var ratedLbl: UILabel! // tmdb api 7
    @IBOutlet weak var budgetLbl: UILabel! // tmdb api 1
    @IBOutlet weak var boxOfcLbl: UILabel! // tmdb api 1
    @IBOutlet weak var runTimeLbl: UILabel! // tmdb api 1
    
    @IBOutlet weak var castCollectionView: UICollectionView! // tmdb api 2
    @IBOutlet weak var genreCollectionView: UICollectionView! // tmdb api 1 + 5
    @IBOutlet weak var suggestionCollectionView: UICollectionView! // tmdb api 4
    
    var selectedMovie: Movie!
    var similarMovies = [Movie]()
    
//    var newlineView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setGradientBackground()
        background_image.addBlurEffect()
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        avgRatingStarView.settings.fillMode = .half
        myRatingStarView.settings.fillMode = .half
        myRatingStarView.rating = 0.0
        
        
        let movieId = SELECTED_MOVIE.getId
        
        
        
        
        print("Movie Id \(movieId)")
        
        getReviews(movieId: movieId)
       
        
        
        getMovieDetails(movieId: movieId)
        
        //get suggested movies
        getSimilarMovies(movieId: movieId)
        
        //        castCollectionView.delegate = self
        //        castCollectionView.dataSource = self
        
        //        genreCollectionView.delegate = self
        //        genreCollectionView.dataSource = self
        //
        //        suggestionCollectionView.delegate = self
        //        suggestionCollectionView.dataSource = self
        
        castCollectionView.backgroundColor = UIColor.clear
        
        UnderlineBtnWithColor()
    }
    
   
    
    fileprivate func UnderlineBtnWithColor() {
        var newlineView = UIView(frame: CGRect(x: 0, y: communityReviewBtn.frame.size.height, width: communityReviewBtn.frame.size.width, height: 2))
        
        newlineView.tag = 23
        
        newlineView.backgroundColor = BLUE_COLOR
        if (self.view.viewWithTag(23) == nil){
            communityReviewBtn.addSubview(newlineView)
            communityReviewBtn.backgroundColor = UIColor.green
            communityReviewBtn.setTitleColor(BLUE_COLOR, for: .normal)
        }
    }
    
    @IBAction func communtiyReviewAction(_ sender: UIButton) {
        button_index = 0
        reviews.removeAll()
        var newlineView = UIView(frame: CGRect(x: 0, y: communityReviewBtn.frame.size.height, width: communityReviewBtn.frame.size.width, height: 2))
        if (self.view.viewWithTag(23) == nil){
            communityReviewBtn.addSubview(newlineView)
            communityReviewBtn.setTitleColor(BLUE_COLOR, for: .normal)
        }
        if let viewWithTag = self.view.viewWithTag(21) {
            //            println("Tag 100")
            friendsReviewBtn.setTitleColor(UIColor.white, for: .normal)
            viewWithTag.removeFromSuperview()
        }

         getReviews(movieId: SELECTED_MOVIE.getId)
//         self.communityTableView.reloadData()

    }
    
    @IBAction func friendsReviewAction(_ sender: UIButton) {
        button_index = 1
        var lineView = UIView()
        lineView = UIView(frame: CGRect(x: 0, y: friendsReviewBtn.frame.size.height, width: friendsReviewBtn.frame.size.width, height: 2))
        lineView.backgroundColor = BLUE_COLOR
        lineView.tag = 21
        
        
        if (self.view.viewWithTag(21) == nil){
            friendsReviewBtn.addSubview(lineView)
            friendsReviewBtn.setTitleColor(BLUE_COLOR, for: .normal)
        }
        
//        if let viewWithTag = self.view.viewWithTag(20) {
//        communityReviewBtn.setTitleColor(UIColor.white, for: .normal)
//            viewWithTag.removeFromSuperview()
//
//        }
        
        if let viewWithTag = self.view.viewWithTag(23) {
            //            println("Tag 100")
            communityReviewBtn.setTitleColor(UIColor.white, for: .normal)
            viewWithTag.removeFromSuperview()
        }
        
        self.communityTableView.reloadData()
        
    }
    
    
    
    func getReviews(movieId: Int) {
        
        reviews.removeAll()
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/reviews?language=en-US&api_key=\(MOVIEDB_API_KEY)"
        
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            
            print(response)
            
            let results = response.response as? [String: AnyObject]
            
            if let value = response.result.value as? [String: AnyObject] {
                
                print(value)
                
                if let valueArray = value["results"] as? NSArray {
                    for value in valueArray {
                        var data = value as! [String: AnyObject]
                        //                        reviews.append(data)
                        print(data)
                        let review = Review(data: data)
//                        self.communityReviews.append(review)
                        self.reviews.append(review)
                        self.NoReviewLbl.isHidden = true
                        self.communityTableView.dataSource = self
                        self.communityTableView.delegate = self
                        self.communityTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getMovieDetails(movieId: Int) {
        print("Mov id: ", movieId)
        let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(MOVIEDB_API_KEY)&language=en-US&&append_to_response=credits,release_dates"
        
        Alamofire.request(url).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                self.selectedMovie = Movie(data: value)
                self.setMovieData(movieData: self.selectedMovie)
                
                self.genreCollectionView.dataSource = self
            }
        }
    }
    
    func getSimilarMovies(movieId: Int) {
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=36bdc526d2d6718ac3da5e000ff36b50&language=en-US&page=1"
        Alamofire.request(url).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["results"] as? NSArray {
                    for value in valueArray {
                        let data = value as! [String: AnyObject]
                        let movie = Movie(data: data)
                        print("name: ", movie.getOriginalTitle)
                        //Checking in firebase if movie exists
                        DataService.instance.currentUserWatchListRef.child("\(movie.getId)").observeSingleEvent(of: .value, with: { (snapshot) in
                            if !(snapshot.exists()) {
                                DataService.instance.currentUserWatchedRef.child("\(movie.getId)").observeSingleEvent(of: .value, with: { (snapshot) in
                                    if !(snapshot.exists()) {
                                        self.similarMovies.append(movie)
                                        self.suggestionCollectionView.dataSource = self
                                        print("name 2: ", movie.getOriginalTitle)
                                        self.suggestionCollectionView.reloadData()
                                    }
                                })
                            }
                        })
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setMovieData(movieData: Movie) {
        self.castCollectionView.dataSource = self
        self.genreCollectionView.dataSource = self
        
        let backdropUrl = URL(string: "http://image.tmdb.org/t/p/w500\(movieData.getBackdropPath)")
        backdropImgView.kf.setImage(with: backdropUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
//        let posterUrl = URL(string: "http://image.tmdb.org/t/p/w342\(movieData.getPosterPath)")
    
        //moviePosterImgView.kf.setImage(with: posterUrl, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        
        if let posterPath = movieData.getPosterPath {
            let url = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            
             moviePosterImgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
      
        
        movieTitleLbl.text = movieData.getOriginalTitle
        
        
        
        let credits = movieData.getCredits
        credits.forEach { (credit) in
            if let job = credit.getJob, job == "Director" {
                directorLbl.text = credit.getName
            }
        }
        
        avgRatingStarView.rating = (movieData.getVoteAverage * 5)/10
        let avgRating = (movieData.getVoteAverage * 5)/10
        ratingLbl.text = "\(avgRating) - \(movieData.getVoteCount) Ratings"
        
        //Check if movie exists in User-Watched list (Watched) else check if in Watchlist (Added to Watchlist) else (Add to Watchlist)
        checkMovieStatus(movieId: movieData.getId)
        
        getMyRating(movieId: movieData.getId)
        
        movieDescriptionLbl.text = movieData.getOverview
        movieDescriptionLbl.sizeToFit()
        
        releaseDateLbl.text = "Release Date: \(movieData.getReleaseDate)"
        
        //        productionCompanyLbl.text = "Production Company: " + movieData.getProductionCompany.joined(separator: ", ")
        
        //get MPAA rating
        
//        print("Mpaa Rating: \(movieData.getMpaaRating)")
        
        if let getRatings = movieData.getMpaaRating {
            ratedLbl.text = "Rated: " + getRatings
        }
        
        
        
        //        let numberFormatter = NumberFormatter()
        //        numberFormatter.numberStyle = NumberFormatter.Style.currencyPlural
        //        let formattedBudget = numberFormatter.string(from: NSNumber(value: movieData.getBudget))
        //        let formattedRevenue = numberFormatter.string(from: NSNumber(value: movieData.getRevenue))
        
        //        budgetLbl.text = "Budget: \(formattedBudget!)"
        //        boxOfcLbl.text = "Revenue: \(formattedRevenue!)"
        //        runTimeLbl.text = "Runtime: \(movieData.getRuntime)"
        
        // Change view height
        //        mainViewHeightConstraint.constant = mainViewHeightConstraint.constant + movieDescriptionLbl.frame.height
    }
    
    func getMyRating(movieId: Int) {
        let currId = DataService.instance.currentUserID
        DataService.instance.movieRef.child("\(movieId)").child("ratings").child(currId).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                var myRating = (snapshot.value as! Double)
                self.myRatingStarView.rating = myRating
            } else {
                var myRating = 0.0
                self.myRatingStarView.rating = myRating
            }
        })
    }
    
    func checkMovieStatus(movieId: Int) {
        DataService.instance.currentUserWatchedRef.child("\(movieId)").observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()) {
                // exists in watched ref
                print("Watched")
                self.updateButton(title: "Watched", flag: true, color: BLUE_COLOR)
            } else {
                DataService.instance.currentUserWatchListRef.child("\(movieId)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if (snapshot.exists()) {
                        //exists in watchlist ref
                        print("Remove")
                        self.updateButton(title: "Remove from Watchlist", flag: true, color: UIColor.black)
                    } else {
                        // add to watchlist
                        print("Add to Watchlist")
                        self.updateButton(title: "Add to Watchlist", flag: true, color: BLUE_COLOR)
                    }
                })
            }
        })
    }
    
    func updateButton(title: String, flag: Bool, color: UIColor) {
        self.watchedBtn.backgroundColor = color
        self.watchedBtn.setTitle(title, for: .normal)
        if flag {
            self.watchedBtn.isUserInteractionEnabled = false
        } else {
            self.watchedBtn.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func writeReviewBtnAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "writeReviewSegue", sender: self)
    }
    
    // Collection View Data Source
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            if collectionView == castCollectionView {
//                return CGSize(width: 120, height: 150)
//            } else if collectionView == genreCollectionView {
//                return CGSize(width: self.view.frame.width/4, height: 30)
//            } else if collectionView == suggestionCollectionView {
//                return CGSize(width: 110, height: 150)
//            } else {
//                return CGSize(width: 0, height: 0)
//            }
//        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            if collectionView == suggestionCollectionView{
                 return CGSize(width: 100, height: 150)
            } else if collectionView == castCollectionView{
                return CGSize(width: 70, height: 150)
            } else {
                return CGSize(width: 0, height: 0)
            }
            
    
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView {
            return self.selectedMovie.getCredits.count
        } else if collectionView == genreCollectionView {
            return (self.selectedMovie.getGenres.count)
            return 0
        } else if collectionView == suggestionCollectionView {
            return self.similarMovies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "creditsCell", for: indexPath) as! CastCollectionViewCell
            cell.configureCell(userInfo: self.selectedMovie.getCredits[indexPath.row])
            return cell
        }
        
        if collectionView == genreCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
            cell.configureCell(genre: self.selectedMovie.getGenres[indexPath.row])
            return cell
        }
            
        else if collectionView == suggestionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as! SuggestedMovieCollectionViewCell
            cell.configureCell(movieInfo: self.similarMovies[indexPath.row])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "creditsCell", for: indexPath) as! CastCollectionViewCell
            return cell
        }
        
    }
    
    @IBAction func addToWatchlistBtnAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add to Watchlist" {
            
            if UserDefaults.standard.object(forKey: "USERNAME") != nil {
                let username = UserDefaults.standard.string(forKey: "USERNAME")!
                addToActivityLog(action: "\(username) Added to Watchlist")
            }
        }
    }
    
    func addToActivityLog(action: String) {
        //Add activity in current user activity-log
        let currentTime = Date().timeIntervalSince1970 * 1000
        
        let currentUserId = DataService.instance.currentUserID
        let activityId = DataService.instance.currentUserActivityLogRef.childByAutoId()
        let activityDetail = ["ownerId": currentUserId,
                              "movieId": "\(self.selectedMovie.getId)",
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "writeReviewSegue" {
        //            let destVc = segue.destination as!
        //        }
    }
    
    @IBOutlet weak var gradient_view: UIView!
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        //        self.view.layer.insertSublayer(gradientLayer)
        self.gradient_view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension IndividualMovieViewController: UITableViewDataSource,UITableViewDelegate {
    
//    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
//
//        return 3
//
//    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 5
//    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int
//    {
//
//        var numOfSections: Int = 0
//        if reviews.count > 0
//        {
//            //            tableView.separatorStyle = .singleLine
//            numOfSections            = 1
//            //            tableView.backgroundView = nil
//        }
//        else
//        {
//
//        }
//        return numOfSections
//    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if button_index == 0 {
            return reviews.count
        }
        else if button_index == 1{
//            return acceptedOrders.count
            
            return 0
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if button_index == 0 {

            
            print(reviews.count)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommRevCell", for: indexPath) as? CommunityReviewsTableViewCell
            cell?.follower_image.layer.cornerRadius = (cell?.follower_image.frame.size.width)!/2
            cell?.follower_image.clipsToBounds = true
            cell?.author_name.text = reviews[indexPath.row].getAuthor
            cell?.review_description.text = reviews[indexPath.row].getContent
            return cell!
            
        } else if button_index == 1 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsRevCell", for: indexPath)
            return cell
        }
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
  
}
extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}





