//
//  FeedTableViewCell.swift
//  Cinneco
//
//  Created by Asher Ahsan on 01/09/2017.
//  Copyright © 2017 Asher Ahsan. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
import Alamofire

class FeedTableViewCell: UITableViewCell {
    //@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var directorLbl: UILabel!
    @IBOutlet weak var popularLbl: UILabel!
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var starringLbl: UILabel!
    @IBOutlet weak var avgRatingStars: CosmosView!
    @IBOutlet weak var addToWatchlistBtn: UIButton!
    @IBOutlet weak var readReviewsBtn: UIButton!
    @IBOutlet weak var myRatingStars: CosmosView!
    
    var movie: Movie!
    var starsArray = [Star]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //spinner.isHidden = true
//        starringLbl.text = ""
        
        myRatingStars.settings.fillMode = .half
        
        myRatingStars.rating = 0.0
        
        myRatingStars.didFinishTouchingCosmos = { rating in
            let userId = DataService.instance.currentUserID
            let rating = rating
            
            DataService.instance.movieRef.child("\(self.movie.getId)").child("ratings").updateChildValues([userId: rating], withCompletionBlock: { (error, reference) in
                DataService.instance.currentUserWatchListRef.child("\(self.movie.getId)").removeValue(completionBlock: { (error, reference) in
                    DataService.instance.currentUserWatchedRef.child("\(self.movie.getId)").setValue(true)
                })
                
                if UserDefaults.standard.object(forKey: "USERNAME") != nil {
                    let username = UserDefaults.standard.string(forKey: "USERNAME") as! String
                    self.addToActivityLog(action: "\(username) rated \(rating) stars")
                }
            })
        }
    }
    
    func configureCell(movieData: Movie) {
        self.movie = movieData
        
//        addToWatchlistBtn.backgroundColor = UIColor(red:0.16, green:0.74, blue:0.92, alpha:1.0)
        
        readReviewsBtn.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
        addToWatchlistBtn.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
        addToWatchlistBtn.setTitle("Add to Watchlist", for: .normal)

//        if let genre = movie.getGenres[0].getName {
//            self.popularLbl.text = "Popular on Cinneco in \(genre)"
//        }
        
        //setGenreName(genreId: movie.getGenreIds.first!.getName)
        movieTitleLbl.text = movieData.getOriginalTitle
        setStarringLbl(movieId: movieData.getId)
        
        //4.01 - 26,453 Ratings
        //avgRatingsLbl.text = String((movieData.getVoteAverage * 5)/10) + " - " + String(movieData.getVoteCount) + " Ratings"
        avgRatingStars.rating = (movieData.getVoteAverage * 5)/10
        
        if let posterPath = movieData.getPosterPath {
            let url = URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
            posterImgView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "loadingImg"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    func getMyRating() {
        let currId = DataService.instance.currentUserID
        DataService.instance.movieRef.child("\(movie.getId)").child("ratings").child(currId).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.myRatingStars.rating = (snapshot.value as! Double)
            } else {
                self.myRatingStars.rating = 0.0
            }
        })
    }
    
    func setStarringLbl(movieId: Int) {
        let STARRING_NAME_API = "http://api.themoviedb.org/3/movie/\(movieId)/casts?api_key=\(MOVIEDB_API_KEY)"
        Alamofire.request(STARRING_NAME_API).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["cast"] as? NSArray {
                    if valueArray.count > 0 {
                        let data = valueArray[0] as! [String: AnyObject]
                        let star = Star(data: data)
                        //self.starsArray.append(star)
                        //Next Line Temp
//                        self.starringLbl.text = star.getName
                    } else {
                        self.starringLbl.text = "N/A"
                    }
                }
            }
        }
    }

    func setGenreName(genreId: Int) {
        Alamofire.request(GENERE_LIST_URL).responseJSON { response in
            if let value = response.result.value as? [String: AnyObject] {
                if let valueArray = value["genres"] as? NSArray {
                    for data in valueArray {
                        let genre = Genre(data: data as! [String : AnyObject])
                        
                        print(genre.getId)
                        
                        if genre.getId == genreId {
                            if let name = genre.getName {
                                self.popularLbl.text = "Popular on Cinneco in \(name)"
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addToActivityLog(action: String) {
        //Add activity in current user activity-log
        let currentTime = Date().timeIntervalSince1970 * 1000
        let currentUserId = DataService.instance.currentUserID
        let activityId = DataService.instance.currentUserActivityLogRef.childByAutoId()
        let activityDetail = ["ownerId": currentUserId,
                              "movieId": "\(self.movie.getId)",
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
